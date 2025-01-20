<?php
if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $firstName = $_POST["firstName"];
    $lastName = $_POST["lastName"];
    $dob = $_POST["dob"];
    $branch = $_POST["branch"];
    $phone_no = $_POST["phone_no"];
    $hostel = $_POST["hostel"];
    $CPI = $_POST["CPI"];

    try {
        require_once "dbh.inc.php";

        // creating query for insert
        $query = "INSERT INTO students (First_name,Last_name,DOB,branch,Phone_no,Hostel,GPA)
                    VALUES(:firstName,:lastName,:dob,:branch,:phone_no,:hostel,:CPI);";

        $stmt = $pdo->prepare($query);

        $stmt->bindParam(":firstName", $firstName);
        $stmt->bindParam(":lastName", $lastName);
        $stmt->bindParam(":dob", $dob);
        $stmt->bindParam(":branch", $branch);
        $stmt->bindParam(":phone_no", $phone_no);
        $stmt->bindParam(":hostel", $hostel);
        $stmt->bindParam(":CPI", $CPI);

        $stmt->execute();

        // ending the query by freeing variables
        $pdo = null;
        $stmt = null;

        // pop up upon submission
        echo '<script type="text/javascript">
                alert("Record successfully inserted. Press enter to continue");
                window.location.href = "../index.php";
                </script>';


        die();
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    header("Location: ../index.php");
}
