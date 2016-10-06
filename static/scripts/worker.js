const get = (url, callback) => {
  let xhr = new XMLHttpRequest();

  xhr.onload = () => {
    if (xhr.status === 200) {
      let data;
      try {
        data = JSON.parse(xhr.responseText);
      } catch (e) {
        console.log(xhr.responseText);
      }

      callback(data);
    } else {
      console.log('error');
    }
  };

  xhr.open('GET', url, true);
  xhr.send();
};

onmessage = (e) => {
  const url = e.data;

  get(url, (data) => {
    postMessage(data);
  });
};
