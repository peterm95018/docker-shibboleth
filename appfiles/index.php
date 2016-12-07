<html>
<body>
<?php
echo "Hello world ! You are authenticated." . "</br>";
// Do we have any variables defined in attribute map
if (isset($_SERVER['eppn'])){
        echo '<a href=' . ' "/Shibboleth.sso/Logout">' . 'Logout' . '</a></br>';
echo 'Your eduPersonPrincipalName (eppn) is : '.$_SERVER['eppn'].' who has an affiliation of '.$_SERVER['unscoped-affiliation'] . '</br>';

echo 'You may also be known as ' . $_SERVER['givenName'] . ' ' . $_SERVER['surname'];


echo '<h3>Dump $_SERVER </h3>';
echo '<pre>';
echo print_r($_SERVER);
echo '</pre>';

}
// or any attributes starting with Shib-
else {
echo 'You are unknown !';
}
?>
</body>
</html>
