<?php

require_once '/etc/polony-tools/config.php';

mysql_connect($mogilefs_mysql_host,
	      $mogilefs_mysql_username,
	      $mogilefs_mysql_password);
echo mysql_error();
mysql_select_db($mogilefs_mysql_database);
echo mysql_error();

mysql_query("create table if not exists md5
(
 fid bigint(20) unsigned not null,
 md5 char(32),
 primary key (fid)
) engine=innodb");
echo mysql_error();

function mogilefs_getfid($dkey, $domain="default")
{
  $q = mysql_query("select
     file.fid
     from file
     left join domain on domain.dmid=file.dmid
     where file.dkey='$dkey'
     and domain.namespace='$domain'");
  $row = mysql_fetch_row($q);
  if ($row)
    return $row[0];
  else
    return false;
}

function mogilefs_getmd5($fid)
{
  $q = mysql_query("select
     md5,
     concat('http://',hostip,':',http_port,'/dev',device.devid)
     from file
     left join file_on on file_on.fid=file.fid
     left join device on device.devid=file_on.devid
     left join host on host.hostid=device.hostid
     left outer join md5 on md5.fid=file.fid
     where file.fid='$fid'
     order by rand()");
  $row = mysql_fetch_row($q);
  if (!$row)
    return false;
  list ($md5, $devpath) = $row;
  if (strlen($md5) != 32)
    {
      $fid = sprintf("%010d", $fid);
      $url = $devpath."/"
	.substr($fid,0,1)."/"
	.substr($fid,1,3)."/"
	.substr($fid,4,3)."/"
	.$fid.".fid";
      $md5 = md5_file($url);
      mysql_query("replace delayed into md5 (fid,md5) values ('$fid','$md5')");
    }
  return $md5;
}

// arch-tag: a79a2139-fce6-11db-9207-0015f2b17887
?>
