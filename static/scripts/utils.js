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

export function renderFrame({id, url, body, sandbox = ''}) {
  const iframe = document.createElement('iframe');
  iframe.id = id;
  iframe.className = 'content';
  iframe.sandbox = sandbox;
  iframe.srcdoc = clean(url, body);

  return iframe;
}

// Prereqs:
//  * base ends in /
//  * relative does not start with /
const absolute = (base, relative) => {
  let stack = base.split('/');
  let parts = relative.split('/');

  stack.pop();

  for (let i = 0; i < parts.length; i++) {
    if (parts[i] === '.') {
      continue;
    }

    if (parts[i] === '..') {
      stack.pop();
    } else {
      stack.push(parts[i]);
    }
  }

  return stack.join('/');
}

const toAbsoluteUrl = (domain, path, relativeUrl) => {
  if (_.first(relativeUrl) === '/') {
    return domain + relativeUrl;
  } else {
    return absolute(domain + path, relativeUrl);
  }
};

// TODO: maybe push this to a worker?
export function clean(url, body) {
  let $body = $(body).wrapAll('<html></html>').parent();
  let parser = document.createElement('a');
  parser.href = url;

  const domain = parser.protocol + '//' + parser.host;
  const path = parser.pathname;

  $body.find('link[rel="stylesheet"]').each((i, stylesheet) => {
    const href = stylesheet.getAttribute('href');
    if (href && !ABSOLUTE_URL.test(href)) {
      stylesheet.href = toAbsoluteUrl(domain, path, href);
    }
  });

  $body.find('script').each((i, script) => {
    const src = script.getAttribute('src');
    if (src && !ABSOLUTE_URL.test(src)) {
      script.src = toAbsoluteUrl(domain, path, src);
    }
  });

  $body.find('img').each((i, img) => {
    const src = img.getAttribute('src');
    if (src && !ABSOLUTE_URL.test(src)) {
      img.src = toAbsoluteUrl(domain, path, src);
    }
  });

  $('video').removeAttr('autoplay');

  return $body.prop('outerHTML');
}
