import $ from 'jquery';

import MyWorker from 'worker?inline=true!./worker';

$(document).ready(() => {
  const worker = new MyWorker();

  worker.addEventListener('message', (e) => {
    console.log(e.data);
  }, false);

  worker.postMessage('http://localhost:8081/hn');

  /*
  $.get('/hn').then((resp) => {
    console.log(resp);
  });
  */
});
