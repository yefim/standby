import _ from 'lodash';

let Posts = function() {
  this.posts = [];
};

Posts.prototype.add = function(newPosts) {
  this.posts.push(...newPosts);
};

Posts.prototype.find = function(id) {
  return _.find(this.posts, (post) => {
    return post.id === id;
  });
};

export default Posts;
