<%@ page contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link href="${webappRoot}/resources/css/board.css" type="text/css" rel="stylesheet" />
</head>
<body>

   <h1>List Page</h1>

   <br>
   <a href="/board/register">register</a>
   <br>
   <br>

   <table class="table table-striped table-bordered table-hover" border="1">
      <thead>
         <tr>
            <th>#번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
            <th>수정일</th>
         </tr>
      </thead>

      <c:forEach items="${list}" var="board">
         <tr>
            <td><c:out value="${board.bno}" /></td>
            
            
<%--             <td><a href='/board/get?bno=<c:out value="${board.bno}"/>'><c:out --%>
<%--                      value="${board.title}" /></a></td> --%>

            <td>
            	<a class='move' href='<c:out value="${board.bno}"/>'> 
            		<c:out value="${board.title}" />
            	</a>
            </td> 

            <td><c:out value="${board.writer}" /></td>
            <td><fmt:formatDate pattern="yyyy-MM-dd"
                  value="${board.regdate}" /></td>
            <td><fmt:formatDate pattern="yyyy-MM-dd"
                  value="${board.updateDate}" /></td>
         </tr>
      </c:forEach>
   </table>
   
   <!-- p 311 -->
		<form id='actionForm' action="/board/list" method='get'>
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			<input type='hidden' name='type'
				value='<c:out value="${ pageMaker.cri.type }"/>'> 
			<input type='hidden' name='keyword'
				value='<c:out value="${ pageMaker.cri.keyword }"/>'>
		</form>
   
   
	   <!-- p 308 -->
	   <div class='pull-right'>
	      <ul class="pagination"> 
	          <c:if test="${pageMaker.prev}">
	              <li class="paginate_button previous"><a href="${pageMaker.startPage - 1 }">Previous</a>
	              </li>
	            </c:if> 
	            <c:forEach var="num" begin="${pageMaker.startPage}"
	              end="${pageMaker.endPage}">
	              <li class="paginate_button"><a href="${num }">${num}</a></li>
	            </c:forEach>
	            <c:if test="${pageMaker.next}">
	              <li class="paginate_button next"><a href="${pageMaker.endPage + 1 }">Next</a></li>
	            </c:if>  
	      </ul>
	   </div>
	   <!--  end Pagination -->   

   <br>


<script>
   $(document).ready(function(){
      var result = '<c:out value="${result}"/>';
      
      checkModal(result);
      
      // p.257
      history.replaceState({}, null, null);
      
      function checkModal(result){
         if(result === '' || history.state) return;
         if( parseInt(result)>0 ) alert("게시글 " + parseInt(result) +" 번이 등록되었습니다. "); 
      }
      
      	// 페이징처리
		var actionForm = $("#actionForm");

		$(".paginate_button a").on(
				"click",
				function(e) {

					e.preventDefault();

					console.log('click');

					actionForm.find("input[name='pageNum']")
							.val($(this).attr("href"));
					actionForm.submit();
				});

		$(".move").on("click",function(e) {
			e.preventDefault();
			actionForm.append("<input type='hidden' name='bno' value='"
				+ $(this).attr("href") + "'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		});

		var searchForm = $("#searchForm");

		$("#searchForm button").on(
				"click",
				function(e) {

					if (!searchForm.find("option:selected")
							.val()) {
						alert("검색종류를 선택하세요");
						return false;
					}

					if (!searchForm.find(
							"input[name='keyword']").val()) {
						alert("키워드를 입력하세요");
						return false;
					}

					searchForm.find("input[name='pageNum']")
							.val("1");
					e.preventDefault();

					searchForm.submit();

				});
   });
</script>

</body>
</html>