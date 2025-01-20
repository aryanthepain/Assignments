<?php
function display_alert($message = "Invalid message", $location = "index.php")
{
    echo '<script type="text/javascript">
                alert("' . $message . '");
                window.location.href = "' . $location . '";
                </script>';
}
