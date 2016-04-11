<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*,com.jspsmart.upload.SmartUpload"%>
<%@ page import="com.running.util.DateUtils"%>
<%
	SmartUpload su = new SmartUpload();
	//上传初始化
	su.initialize(pageContext);
	// 设定上传限制
	//1.限制每个上传文件的最大长度//90M
	su.setMaxFileSize(90485760);
	//2.限制总上传数据的长度。
	su.setTotalMaxFileSize(10485760*100);
	//3.设定允许上传的文件（通过扩展名限制）,仅允许doc,txt,xls,ppt文件。
	su.setAllowedFilesList("jpg,jpeg,png,gif,doc,xls,txt,ppt,docx,xlsx,pptx,pdf,rar,zip,PDF");
	boolean sign = true;
	String fileName = "";//附件存储名称
	String filename="";//附件名称
	String fileTitle="";//附件名称
	String fileType="";//附件类型
	String fileFolder ="";//附件文件夹
	String rootDir = config.getServletContext().getRealPath("/").replaceAll("\\\\","/");	//根目录
	//rootDir = rootDir.replace("gcgov","").replace("gcunit","");
	//while (rootDir.endsWith("/")) {
	//	rootDir = rootDir.substring(0,rootDir.length()-1);
	//}
	rootDir = rootDir+"uploadImg";
	//String rootDir = "D:/Javamyeclipes/workspace/egjcms/WebRoot";
	//String rootDir = "D:/workspace/egjcms/WebRoot";
	//相对路径
	String fileDir ="fileDir";
	fileFolder =DateUtils.getDate("yyyy/MM/dd");
	//物理绝对路径=root+"/"+fileDir
	String sUploadDir = rootDir;

	int fileSize = 0;
	//4.设定禁止上传的文件（通过扩展名限制）,禁止上传带有exe,bat,jsp,htm,html扩展名的文件和没有扩展名的文件。
	try {
		//在物理绝对路径上创建文件夹
		new File(sUploadDir).mkdirs();
		su.setDeniedFilesList("exe,bat,jsp,htm,html");
		//上传文件
		su.upload();
		for (int i=0;i<su.getFiles().getCount();i++){
            com.jspsmart.upload.File myFile = su.getFiles().getFile(i);
           //String str=new String(myFile.getFileName().getBytes(),"utf-8");
           String str=myFile.getFileName();
            int b=str.lastIndexOf(".");
            filename=str.substring(0,b);//附件名称
            fileType=str.substring(b+1,str.length());//附件类型
            if (!myFile.isMissing()) {
              fileName =DateUtils.getDate("yyyyMMddHHmmssS");//附件存储名称
              //上传后的HTTP文件路径
              myFile.saveAs(sUploadDir+"/"+fileName+"."+myFile.getFileExt());
              fileSize = (myFile.getSize()/1024)+1;
            }
         }
	} catch (Exception e) {
		e.printStackTrace();
		sign = false;
	}
	
	if(sign==true){
		out.println("<script>parent.fnCallback3('"+fileTitle+"','"+fileType+"','"+fileSize+"','"+rootDir+"','"+fileName+"','upload file success')</script>");
	}else{
		out.println("<script>parent.fnCallback('','','0','','','upload file error')</script>");
		
	}
%>