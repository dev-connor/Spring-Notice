<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@include file="/WEB-INF/views/include/title.jsp" %>
</head>
<body>

   <h1>Modify Page</h1>
   
   <div class="panel-body">

      <div class="form-group">
        <label>Bno</label> 
        <input value='<c:out value="${board.bno }"/>' disabled>
      </div>
      <div class="form-group">
        <label>Writer</label> 
        <input value='<c:out value="${board.writer}"/>' disabled>            
      </div>
      <form role="form" action="/board/modify" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      
        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
        <input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
       <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
      <input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
      
      <div class="form-group">
        <input class="form-control" name='bno' 
           value='<c:out value="${board.bno }"/>' hidden>
      </div>
 
      
      <div class="form-group">
        <label>Title</label> 
        <input class="form-control" name='title' 
          value='<c:out value="${board.title }"/>' >
      </div>
      
      <div class="form-group">
        <label>Text area</label>
        <textarea class="form-control" rows="3" name='content' ><c:out value="${board.content}"/></textarea>
      </div>
      
      
   
             
   	 <!-- 검색조건/검색어/페이지번호 -->
     <button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
     <button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
     <button type="submit" data-oper='list' class="btn btn-info">List</button>
     
   </form>
      <div class="form-group">
        <label>RegDate</label> 
        <input class="form-control" name='regDate'
          value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.regdate}" />'  disabled>            
      </div>
      
      <div class="form-group">
        <label>Update Date</label> 
        <input class="form-control" name='updateDate'
          value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.updateDate}" />'  disabled>            
      </div>


   </div> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
   $(document).ready(function(){
       var formObj = $("form");

        $('button').on("click", function(e){
          
          e.preventDefault(); 
          
          var operation = $(this).data("oper");
          
          console.log(operation);
          
          if(operation === 'remove'){
            formObj.attr("action", "/board/remove");
            
          }else if(operation === 'list'){
            //move to list
            formObj.attr("action", "/board/list").attr("method","get");
            
            var pageNumTag = $("input[name='pageNum']").clone();
            var amountTag = $("input[name='amount']").clone();
            var keywordTag = $("input[name='keyword']").clone();
            var typeTag = $("input[name='type']").clone();      
            
            formObj.empty();
            
            formObj.append(pageNumTag);
            formObj.append(amountTag);
            formObj.append(keywordTag);
            formObj.append(typeTag);          
          }
          
          formObj.submit();
        });
   });
</script>
   

    
</body>
</html>