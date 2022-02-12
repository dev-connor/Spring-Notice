<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@include file="/WEB-INF/views/include/title.jsp" %>
</head>
<body>

   <h1>Get Page</h1>

   <div class="panel-body">

      <div class="form-group">
         <label>Bno</label> <input class="form-control" name='bno'
            value='<c:out value="${board.bno }"/>' disabled>
      </div>
      
      <div class="form-group">
         <label>Writer</label> <input class="form-control" name='writer'
            value='<c:out value="${board.writer }"/>' disabled>
      </div>      

      <div class="form-group">
         <label>Title</label> <input class="form-control" name='title'
            value='<c:out value="${board.title }"/>' disabled>
      </div>

      <div class="form-group">
         <label>Text area</label>
         <textarea class="form-control" rows="3" name='content'
            disabled><c:out value="${board.content}" /></textarea>
      </div>
      


    <!-- 작성자만 수정/삭제 -->	      
	<sec:authentication property="principal" var="p"/>
	<sec:authorize access="isAuthenticated()">
		<c:if test="${p.username eq board.writer }">
			<button data-oper='modify' class="btn btn-default">
				<a href="/board/modify?bno=<c:out value='${board.bno}'/>">수정</a>
			</button>			
			<form role="form" action="/board/remove?bno=${board.bno }" method="post">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
			</form>
		</c:if>
	</sec:authorize>
	
	<button data-oper='list' class="btn btn-info">
		<a href="/board/list">목록</a>
	</button>
      
      
      <form id='operForm' action="/board/modify" method="get">
        <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
        <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
        
<%--         <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'> --%>
<%--         <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>   --%>
      </form> 
      
   </div>   
</body>
</html>