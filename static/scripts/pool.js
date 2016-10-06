import Crawler from 'worker?inline=true!./worker';

let Pool = function() {
  this.workers = [];
  this.count = 0;
};

Pool.prototype.getWorker = function() {
  if (this.workers.length > 0) {
    return this.workers.pop();
  } else if (this.count < 10) {
    this.count++;
    return new Crawler();
  } else {
    // TODO: we might not need this many workers :D
    // enqueue that shit
    // maybe have one worker manage the queue?
  }
};

Pool.prototype.releaseWorker = function(worker) {
  this.workers.push(worker);
};

export default Pool;
