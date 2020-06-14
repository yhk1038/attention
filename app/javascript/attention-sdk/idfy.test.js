import test from './test'
import idfy from './idfy'


const id = idfy('#NT-1');
test(id.keyType).equal('NT-1');
