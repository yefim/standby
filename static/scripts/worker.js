const get = (url, callback) => {
  let xhr = new XMLHttpRequest();

  xhr.onload = () => {
    if (xhr.status === 200) {
      let data;
      try {
        data = JSON.parse(xhr.responseText);
      } catch (e) {
        postMessage({success: false});
      }

      callback(data);
    } else {
      postMessage({success: false});
    }
  };

  xhr.onerror = () => {
    postMessage({success: false});
  };

  xhr.open('GET', url, true);
  xhr.send();
};

onmessage = (e) => {
  const url = e.data;

  get(url, (data) => {
    postMessage({
      url,
      data,
      success: true
    });
  });
};
