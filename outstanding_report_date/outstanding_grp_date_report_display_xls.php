<?php include("../includes/check_session.php");
include("../includes/config.php");
$con=get_connection();

$download='XLS';

$time=time()+19800; // Timestamp is in GMT now converted to IST
$date=date('d_m_Y_H_i_s',$time);

//application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
header ( "Content-type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" );
header ( "Content-Disposition: attachment; filename=Group_outstanding_report_date_".$date.".xls" );
?>

<?php  if($_REQUEST['report_disp']=='OK'){ $rep_print="" ;  $rep_xls="OK"; ?>    
<table border='1' ><tr><td>
<?php include("../includes/header_xls.php"); ?>    
</td></tr>
<tr><td>             
<?php include("outstanding_grp_date_report_display.php"); ?>   
</td>
</tr>
</table>
<?php } ?>  
<?php 
release_connection($con);
?>