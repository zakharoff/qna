$(document).on('turbolinks:load', function () {
    $('.new-comment').on('ajax:success', function(e) {
        var xhr = e.detail[0];
        var resourceName = xhr['commentable_type'].toLowerCase();
        var resourceId = xhr['commentable_id'];
        var resourceContent = xhr['body'];

        $('.' + resourceName + '-' + resourceId + ' .comment-block .comments').append('<div class="comment"><p>'+ resourceContent + '</p></div>');
    })
        .on('ajax:error', function(e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.comment-errors').append('<p>' + index + ' ' + value + '<p>');
            })
        });

    App.cable.subscriptions.create('CommentChannel', {
        connected: function() {
            var questionId = $('.question')[0].classList[1].slice(-1);
            return this.perform('follow', {id: questionId});
        },
        received: function(data) {
            if (gon.user_id != data.comment.author_id) {
                var resourceName = data.comment.commentable_type.toLowerCase();
                var resourceId = data.comment.commentable_id;
                var newComment = JST['templates/comment']({
                    comment: data.comment,
                });

                if (resourceName == 'question') {
                    $('.question .comment-block .comments').append(newComment);
                } else if (resourceName == 'answer') {
                    $('.answers .answer-' + resourceId + ' .comment-block .comments').append(newComment);
                }
            }
        }
    });
});