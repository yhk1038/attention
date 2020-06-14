import Router from '../attention-sdk/router';
import idfy from '../attention-sdk/idfy';

import Draggable from "../attention-sdk/draggable";

import '../stylesheets/attention-sdk.scss';

const log = (...args) => {
  if (log.logLevel === 'debug') console.log('[Attention]', `<${log.start}>`, '|', ...args);
}

class Attention {
  constructor(config) {
    this.version = config.version;
    log.logLevel = config.logLevel;

    this.router = new Router(config);

    this.project_key = null;
    this.template = 'bootstrap4-modal';
    this.notificationIds = [];
  }

  // Ready App & Container DOM
  init(project_key, notificationIds) {
    log.start = 'init'

    log(`Project ${project_key} set. (v${this.version})`);
    this.project_key = project_key;

    log(`프로젝트 키에 기반해, 라이브 중인 공지 아이디들을 사전에 가져와 준비합니다. (${notificationIds})`);
    if (notificationIds) this.notificationIds = notificationIds;

    log('프레임 컨테이너를 body 하단에 삽입합니다. (div#attention-container)');
    const container = document.createElement('div');
    container.id = 'attention-container';
    document.body.insertBefore(container, null);
    this.container = container;

    log('자식 프레임에서 전송한 메세지를 부모프레임에서 받을 수 있습니다.')
    window.addEventListener('message', this.__receiveMessageFromIframe.bind(this), false);
  }

  __receiveMessageFromIframe(e) {
    if (e.data.eventName === 'shown') this.__receiveMessageIframeLoaded(e);
    if (e.data.eventName === 'hidden') this.__receiveMessageIframeFinished(e);
  }

  __receiveMessageIframeLoaded(e) {
    log.start = '__receiveMessageIframeLoaded';

    const self = this;
    const {
      notificationId,
      iframeWidth,
      iframeHeight
    } = e.data;

    log('body 에 상태클래스를 붙여줍니다.');
    document.body.classList.add('attention-show');

    log('임베드된 페이지로부터 데이터를 받아 iframe 의 사이즈를 조정합니다.');
    const iframe = document.getElementById(this.__generateNotificationFrameId(notificationId));
    if (iframeWidth) iframe.width = iframeWidth;
    if (iframeHeight) iframe.height = iframeHeight;

    log('iframe 이 준비 완료되었으니 보여줍니다.');
    iframe.classList.add('loaded');

    log('컨테이너를 클릭하면 iframe 이 꺼지는 클릭핸들러를 바인딩합니다.');
    document.getElementById('attention-container').addEventListener('click', function () {
      self.__removeFrame(iframe);
    });

    // log('iframe 을 Draggable 로 만들어줍니다.');
    // Draggable.init(this.container, iframe);

    log('hit 를 찍습니다.');
    this.hit(notificationId).remove();
  }

  __receiveMessageIframeFinished(e) {
    log.start = '__receiveMessageIframeFinished';

    const { notificationId } = e.data;

    log('iframe 을 제거 프로토콜을 시작합니다.');
    const iframe = document.getElementById(this.__generateNotificationFrameId(notificationId));
    this.__removeFrame(iframe);
  }

  // TODO: 아직 템플릿은 부트스트랩 모달만 지원합니다.
  // set_template(template) {
  //   this.template = template;
  // }

  fire(inLiveNotificationIds) {
    log.start = 'fire';

    log('애초에 실행할 수 없는 경우, 잘못된 요청으로 인식하고 실행을 종료합니다.');
    if (!this.project_key) {
      console.warn(`[Attention] The 'project key' unregistered. Please be sure to run 'Attention.init(KEY)' or 'AT.init(KEY)'`)
      return;
    }

    log('인자가 주어지지 않은 경우, 사전에 가져온 라이브 공지 리스트로 대체합니다.');
    if (!inLiveNotificationIds) {
      inLiveNotificationIds = this.notificationIds;
    }

    log('인자가 주어졌으나 단수형인경우, 복수형으로 바꿔줍니다.');
    if (!(inLiveNotificationIds instanceof Array)) {
      inLiveNotificationIds = [inLiveNotificationIds];
    }

    log('inLiveNotificationIds 루프 시작', 'length:', inLiveNotificationIds.length);
    for (const notificationId of inLiveNotificationIds) {
      this.__appendFrame(notificationId, this.router.fireUrl({ notificationId, template: this.template, origin: window.location.origin }));
    }
  }

  hit(notificationId) {
    if (!notificationId) {
      console.warn(`[Attention] The 'notificationId' is required. Please check your first argument.`);
      return;
    }

    return this.__loadScript(0, this.router.hitUrl({ notificationId }));
  }


  /**
   * Private
   */
  __generateNotificationFrameId(notificationId) {
    return 'attention-frame-notification-'+idfy(notificationId).recordId
  }

  __appendFrame(notificationId, url, option = {}) {
    log.start = '__appendFrame';

    log(`프레임을 스펙에 맞게 구성합니다. (iframe.attention-frame)`);
    const frame = document.createElement('iframe');
    frame.id = this.__generateNotificationFrameId(notificationId);
    frame.src = url;
    frame.width = '100%'
    frame.height = '100%';
    frame.classList.add('attention-frame');
    frame.classList.add('fade');
    frame.setAttribute('allowtransparency', 'true');
    frame.setAttribute('frameborder', '0');
    frame.setAttribute('scrolling', 'no');
    frame.setAttribute('horizontalscrolling', 'no');
    frame.setAttribute('verticalscrolling', 'no');

    log(`컨테이너에 프레임을 삽입해줌으로써 알림 페이지를 가져옵니다. (src: ${url})`);
    this.container.insertBefore(frame, null);
  }

  __removeFrame(frame) {
    log.start = '__removeFrame'

    log('fadeOut 의 효과를 위해 클래스를 제거합니다.');
    frame.classList.remove('loaded');

    log('opacity transition duration 으로 설정된 200ms 를 기다렸다가');
    setTimeout(function () {
      log('iframe 을 삭제하고, body 에 클래스를 지워줍니다.');
      frame.remove();
      document.body.classList.remove('attention-show');
    }, 200);
  }

  // request.load
  __loadScript(id, src, callback) {
    const existingScript = document.querySelector(`script[src="${src}"]`);
    const insertPoint = document.getElementsByTagName('script')[0];
    const scriptTag = existingScript || document.createElement('script');

    if (existingScript) {
      if (callback) callback();
      return scriptTag;
    }

    scriptTag.src = src;
    scriptTag.onload = function() {
      if (callback) callback();
      if (!id) scriptTag.remove();
    };
    scriptTag.async = true;
    insertPoint.parentNode.insertBefore(scriptTag, insertPoint);
    return scriptTag;
  }
}

window.Attention = new Attention({
  version: '1.0.0',
  host: 'http://localhost:3000',
  fire_path: '/sdk/fire',
  hit_path: '/sdk/hit.js',

  /**
   * 콘솔에서 런타임의 자세한 내용을 보려면 아래 주석을 해제해주세요.
   */
  // logLevel: 'debug',
});

/**
<script>
(function(r,a,i,l,s){
  var o="http://localhost:3000/sdk/attention.js?id=";
  var k='stack',y='ready';r[l]=r[l]||{};r[l][k]=[];r[l][y]=
  function(f){r[l][k].push(f)};var f=a.getElementsByTagName(i)[0],
  t=a.createElement(i),an=l != 'AT'?'&sg='+l:'';t.async=true;
  t.src=o+s+an;f.parentNode.insertBefore(t,f)}
)(window,document,'script','AT','<YOUR PROJECT KEY>');
</script>
*/
