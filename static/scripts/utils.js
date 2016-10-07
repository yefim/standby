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
      callback && callback(e.data);
    }
  };
}

export function renderFrame(id, url, body) {
  const iframe = document.createElement('iframe');
  iframe.id = id;
  iframe.className = 'content';
  iframe.sandbox = 'allow-scripts';
  iframe.srcdoc = clean(url, body);

  return iframe;
}

const toAbsoluteUrl = (domain, path, relativeUrl) => {
  if (_.last(domain) === '/' && _.first(relativeUrl) === '/') {
    return domain + relativeUrl.substring(1);
  } else if (_.last(domain) !== '/' && _.first(relativeUrl) !== '/') {
    return domain + path + '/' + relativeUrl;
  } else {
    return domain + relativeUrl;
  }
};

// TODO: maybe push this to a worker?
export function clean(url, body) {
  let $body = $(body).wrapAll('<html></html>').parent();
  let parser = document.createElement('a');
  parser.href = url;
  const domain = parser.protocol + '//' + parser.host;
  const path = parser.pathname

  $body.find('link[rel="stylesheet"]').each((i, stylesheet) => {
    if (stylesheet.href && !ABSOLUTE_URL.test(stylesheet.href)) {
      stylesheet.href = toAbsoluteUrl(domain, path, stylesheet.href);
    }
  });

  $body.find('script').each((i, script) => {
    if (script.src && !ABSOLUTE_URL.test(script.src)) {
      script.src = toAbsoluteUrl(domain, path, script.src);
    }
  });

  $body.find('img').each((i, img) => {
    if (img.src && !ABSOLUTE_URL.test(img.src)) {
      img.src = toAbsoluteUrl(domain, path, img.src);
    }
  });

  $('video').removeAttr('autoplay');

  return $body.prop('outerHTML');
}
