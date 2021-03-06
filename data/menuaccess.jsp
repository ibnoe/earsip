<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%
Connection	db_con		= null;
Statement	db_stmt		= null;
ResultSet	rs			= null;
String		q			= "";
String		db_url		= "";
String		data		= "";
String		grup_id		= "";
int			i			= 0;
try {
	db_con = (Connection) session.getAttribute ("db.con");

	if (db_con == null || (db_con != null && db_con.isClosed ())) {
		response.sendRedirect (request.getContextPath ());
		return;
	}

	grup_id = request.getParameter ("grup_id");
	if (grup_id == null) {
		out.print ("{success:false,info:'Grup ID tidak diketahui!'}");
		return;
	}

	q	=" select	M.id"
		+" ,		M.pid"
		+" ,		M.nama"
		+" ,		M.nama_ref"
		+" ,		coalesce (MA.hak_akses_id, 0) hak_akses_id"
		+" from			m_menu		M"
		+" left join	menu_akses	MA"
		+" on			M.id		= MA.menu_id"
		+" and			MA.grup_id	= "+ grup_id
		+" order by M.id";

	db_stmt = db_con.createStatement ();
	rs = db_stmt.executeQuery (q);

	while (rs.next ()) {
		if (i > 0) {
			data += ",";
		} else {
			i++;
		}
		data	+="{ id				: "+ rs.getString ("id")
				+ ", pid			: "+ rs.getString ("pid")
				+ ", nama			:'"+ rs.getString ("nama") +"'"
				+ ", nama_ref		:'"+ rs.getString ("nama_ref") +"'"
				+ ", grup_id		: "+ grup_id
				+ ", hak_akses_id	: "+ rs.getString ("hak_akses_id")
				+ "}";
	}

	out.print ("{success:true,data:["+ data +"]}");
	rs.close ();
}
catch (Exception e) {
	out.print ("{success:false,info:'"+ e.toString().replace("'","''") +"'}");
}
%>
