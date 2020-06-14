import idfy from './idfy';

class RouteURL {
  constructor(host) {
    this.url = new URL(host);
  }

  build(path, params_object = {}) {
    this.setPath(path);
    for (const [key, val] of Object.entries(params_object)) {
      this.setParams(key, val);
    }
    return this.url;
  }

  setPath(path) {
    this.url.pathname = path;
    return this;
  }

  setParams(key, val) {
    if (this.url.searchParams.get(key)) {
      this.url.searchParams.set(key, val);
    } else {
      this.url.searchParams.append(key, val);
    }
    return this;
  }
}

class Router {
  constructor({ host, fire_path, hit_path }) {
    // this.builder = new RouteBuilder(host);
    this.host = host;
    this.fire_path = fire_path;
    this.hit_path = hit_path;
  }

  fireUrl({ template, notificationId, origin }) {
    return `${this.host}${this.fire_path}?notification_id=${idfy(notificationId).recordId}&template=${template}&origin=${origin}`;
  }

  hitUrl({ notificationId }) {
    return `${this.host}${this.hit_path}?notification_id=${idfy(notificationId).recordId}`;
  }
}

export default Router
