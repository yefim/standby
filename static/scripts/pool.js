import Crawler from 'worker?inline=true!./worker';

let Pool = function() {
  this.workers = [];
};

Pool.prototype.getWorker = function() {
  if (this.workers.length > 0) {
    return this.workers.pop();
  } else {
    return new Crawler();
  }
};

Pool.prototype.releaseWorker = function(worker) {
  this.workers.push(worker);
};

export default Pool;
