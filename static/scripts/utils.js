import $ from 'jquery';
import _ from 'lodash';

import Pool from './pool';

export const ROOT = 'http://localhost:8081';
const ABSOLUTE_URL = /^(\/\/|http|javascript|data:)/i

const pool = new Pool();

export function crawl(urls, callback) {
  const crawler = pool.getWorker();

  let crawlUrl;
  if (_.isArray(urls)) {
    crawlUrl = `${ROOT}/batch?${$.param({urls})}`;
  } else {
    crawlUrl = urls;
  }

  crawler.postMessage(crawlUrl);
  crawler.onmessage = (e) => {
    pool.releaseWorker(crawler);

    if (e.data.success) {
      console.log(e.data);
      callback && callback(e.data);
    }
  };
}

// TODO: maybe push this to a worker?
export function clean(url, body) {
  let $body = $(body).wrapAll('<html></html>').parent();

  $body.find('link[rel="stylesheet"]').each((i, stylesheet) => {
    if (stylesheet.href && ABSOLUTE_URL.test(stylesheet.href)) {
      stylesheet.href = '';
    }
  });

  $body.find('script').each((i, script) => {
    if (script.src && ABSOLUTE_URL.test(script.src)) {
      script.src = '';
    }
  });

  $body.find('img').each((i, img) => {
    if (img.src && ABSOLUTE_URL.test(img.src)) {
      img.src = '';
    }
  });

  $('video').removeAttr('autoplay');

  return $body.prop('outerHTML');
}
