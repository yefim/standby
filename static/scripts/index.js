import $ from 'jquery';

import Pool from './pool';

$(document).ready(() => {
  const contentSites = ['http://localhost:8081/hn'];
  const pool = new Pool();

  contentSites.forEach((url) => {
    const crawler = pool.getWorker();

    crawler.postMessage(url);

    crawler.onmessage = (e) => {
      console.log(e.data);
    };
  });
});
