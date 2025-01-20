<?php
require_once "../functions/display_alert.php";

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    try {
        require_once "dbh.inc.php";

        $query = 'SELECT * FROM students
                        where Roll_number not IN 
                                        (SELECT Roll_number FROM has_issued WHERE return_date is null);';

        $stmt = $pdo->prepare($query);
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
    <title>Query Results</title>
    <link rel="stylesheet" href="../css/form.css">
</head>

<body>
    <?php
    if (empty($results)) {
        display_alert("No Query results found.");
        die();
    } else { ?>
        <div class="sellform">
            <h1 class="sftitle">Search Results</h1>

            <div class="sfcontainer">

                <?php

                foreach ($results as $row) {
                    include "../forms/searchResultsStudents.php";
                }
                ?>

            </div>
            <button class="sfsubmit" id="go_back_btn" onclick="window.location.href='../index.php'">Go Back</button>
        </div>
    <?php
    }
    ?>
</body>

</html>