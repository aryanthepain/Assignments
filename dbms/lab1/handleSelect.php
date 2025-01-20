<?php
function display_alert($message = "Invalid message", $location = "index.php")
{
    echo '<script type="text/javascript">
                alert("' . $message . '");
                window.location.href = "' . $location . '";
                </script>';
}

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $roll_no = $_POST["roll_no"];
    $firstName = $_POST["firstName"];
    $lastName = $_POST["lastName"];

    try {
        require_once "include/dbh.inc.php";

        // creating query for select
        if (!empty($roll_no)) {
            $query = "SELECT * FROM students WHERE Roll_number=:roll_no;";

            $stmt = $pdo->prepare($query);
            $stmt->bindParam(":roll_no", $roll_no);
        } else if (isset($firstName) and isset($lastName)) {
            $query = 'SELECT * FROM students WHERE First_name=:firstName AND Last_name=:lastName;';

            $stmt = $pdo->prepare($query);
            $stmt->bindParam(":firstName", $firstName);
            $stmt->bindParam(":lastName", $lastName);
        } else {
            $pdo = null;
            $stmt = null;
            display_alert("Use at least one of the search methods.");
            die();
        }
        $stmt->execute();

        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // ending the query by freeing variables
        $pdo = null;
        $stmt = null;
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    display_alert("Error");
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
    <link rel="stylesheet" href="css/form.css">
</head>

<body>
    <?php
    if (empty($results)) {
        display_alert("No search results found.");
        die();
    } else { ?>
        <div class="sellform">
            <h1 class="sftitle">Search Results</h1>

            <div class="sfcontainer">

                <?php

                foreach ($results as $row) {
                    include "forms/searchResults.php";
                }
                ?>

            </div>
            <button class="sfsubmit" id="go_back_btn" onclick="window.location.href='index.php'">Go Back</button>
        </div>
    <?php
    }
    ?>
</body>

</html>