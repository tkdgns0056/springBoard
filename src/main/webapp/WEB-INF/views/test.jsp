<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
</head>
<body>
<h2>commentTest</h2>
comment: <input type="text" name="comment"><br>
<button id="sendBtn" type="button">SEND</button>
<button id="modBtn" type="button">MODIFY</button>
<div id="commentList"></div>

<div id="replyForm" style="display: none">
    <input type="text" name="replyComment">
    <button id="wrtRepBtn" type="button">등록</button>
</div>

<script>
    let bno = 1702;

    <!-- 특정 게시물에 있는 댓글 가져오는 함수 -->
    let showList = function (bno){
        $.ajax({
            type: 'GET',     //요청 메서드
            url: '/ch4/comments?bno='+ bno, //요청 URI
            success: function (result){
                $("#commentList").html(toHtml(result));
;            },
            error : function(){
                alert("error")
            } //에러가 발생했을 때, 호출될 함수
        }); // $.ajax() end
    }

    $(document).ready(function(){
        showList(bno);

        $("#sendBtn").click(function(){
            let comment = $("input[name=comment]").val();

            if(comment.trim()==''){
                alert("댓글을 입력해주세요.");
                $("input[name=comment]").focus()
                return;
            }

            //댓글 쓰는 ajax
            $.ajax({
                type:'POST',       // 요청 메서드
                url: '/ch4/comments?bno=' +bno,  // 요청   // /ch4/comments/?bno=1702 POST
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({bno:bno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                success : function(result){
                    alert(result);
                    showList(bno);
                },
                error : function(){
                    alert("error")  // 에러가 발생했을 때, 호출될 함수
                }
            }); // $.ajax()
        });

        //댓글 수정 ajax
        $("#modBtn").click(function (){
            let cno = $(this).attr("data-cno");
            let comment = $("input[name=comment]").val();

            if(comment.trim()==''){
                alert("댓글을 입력해주세요.");
                $("input[name=comment]").focus()
                return;
            }

            $.ajax({
                type: 'PATCH',
                url: '/ch4/comments/' + cno,
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({cno:cno, comment:comment}),
                success: function (result){
                    alert(result);
                    showList(bno);
                },
                error: function(){
                    alert("error")
                } //에러가 발생할 시 호출하는 메서드
            })
        })

        //리스트에서 수정 버튼 클릭시 데이터 input에 넣어주는 메서드
        $("#commentList").on("click", ".modBtn",function() {
            let cno = $(this).parent().attr('data-cno');
            let comment = $("span.comment", $(this).parent()).text();

            //1. comment의 내용을 input에 뿌려주기
            $("input[name=comment]").val(comment);
            //2. cno전달하기
            $("#modBtn").attr("data-cno", cno);
        });

        //답글 다는 함수
        $("#wrtRepBtn").click(function(){
            let comment = $("input[name=replyComment]").val();
            let pcno = $("#replyForm").parent().attr("data-pcno");

            if(comment.trim()==''){
                alert("답글을 입력해주세요.");
                $("input[name=replyComment]").focus()
                return;
            }

            //답글 쓰는 ajax
            $.ajax({
                type:'POST',       // 요청 메서드
                url: '/ch4/comments?bno=' +bno,  // 요청   // /ch4/comments/?bno=1702 POST
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({pcno:pcno, bno:bno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                success : function(result){
                    alert(result);
                    showList(bno);
                },
                error : function(){
                    alert("error")  // 에러가 발생했을 때, 호출될 함수
                }
            }); // $.ajax()

            //다시 답글을 안보이게 처리 해준다.
            $("#replyForm").css("display", "none");
            //답글 입력란 다시 비워야함.
            $("input[name=replyComment]").val('');
            //원래 위치로 되돌려 놔야함.(body 아래)
            $("#replyForm").appendTo("body");
        });

        //답글 버튼 함수
        $("#commentList").on("click", ".replyBtn",function(){
            //1. replyForm을 옮긴다.
            $("#replyForm").appendTo($(this).parent()); //li태그 뒤에 붙인다.

            //2. 답글 입력할 폼을 보여준다.
            $("#replyForm").css("display", "block");

        });

        //댓글 삭제 ajax
        //$(".delBtn").click(function(){
        //동적으로 생성되는 요소에 이벤트를 거는 방법. on.click
            $("#commentList").on("click", ".delBtn",function(){

                let cno = $(this).parent().attr("data-cno");
                let bno = $(this).parent().attr("data-bno");

                $.ajax({
                    type: 'DELETE',
                    url: '/ch4/comments/'+cno+'?bno='+bno,
                    success: function (result){
                        alert(result)
                        showList(bno);
                    },
                    error : function (){
                        alert ("error");
                    }
                }); //$.ajax() end
            });
    });

    let toHtml = function(comments){
        let tmp = "<ul>";

        comments.forEach(function(comment){
            tmp += '<li data-cno=' + comment.cno
            tmp += ' data-pcno=' + comment.pcno
            tmp += ' data-bno=' + comment.bno + '>'
            if(comment.cno!=comment.pcno)
            tmp += 'ㄴ'
            tmp += ' commenter=<span class="commenter">' + comment.commenter + '</span>'
            tmp += ' comment=<span class="comment">' + comment.comment + '</span>'
            tmp += ' up_date=' +comment.up_date
            tmp += '<button class="delBtn">삭제</button>'
            tmp += '<button class="modBtn">수정</button>'
            tmp += '<button class="replyBtn">답글</button>'
            tmp += '</li>'
        })

        return tmp + "</ul>";
    }
</script>
</body>
</html>