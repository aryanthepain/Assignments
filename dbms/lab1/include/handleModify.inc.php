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
    $dob = $_POST["dob"];
    $branch = $_POST["branch"];
    $phone_no = $_POST["phone_no"];
    $hostel = $_POST["hostel"];
    $CPI = $_POST["CPI"];

    try {
        require_once "dbh.inc.php";


        // creating query for select
        if (empty($roll_no)) {
            $pdo = null;
            $stmt = null;
            display_alert("Enter your Roll Number.");
            die();
        }

        $query = "SELECT * FROM students WHERE Roll_number=:roll_no;";

        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":roll_no", $roll_no);
        $stmt->execute();

        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $stmt = null;

        // creating query for update
        $query = "UPDATE students SET First_name=:firstName,Last_name=:lastName,DOB=:dob,branch=:branch,Phone_no=:phone_no,Hostel=:hostel,GPA=:CPI WHERE Roll_number=:roll_no;";
        $stmt = $pdo->prepare($query);

        // change to updated values, keep same if empty
        $firstName = (empty($firstName)) ? $results[0]["First_name"] : $firstName;
        $lastName = (empty($lastName)) ? $results[0]["Last_name"] : $lastName;
        $dob = (empty($dob)) ? $results[0]["DOB"] : $dob;
        $branch = (empty($branch)) ? $results[0]["branch"] : $branch;
        $phone_no = (empty($phone_no)) ? $results[0]["Phone_no"] : $phone_no;
        $hostel = (empty($hostel)) ? $result[0]["Hostel"] : $hostel;
        $CPI = (empty($CPI)) ? $results[0]["GPA"] : $CPI;

        $stmt->bindParam(":roll_no", $roll_no);
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
                alert("Record successfully updated. Press enter to continue");
                window.location.href = "../index.php";
                </script>';


        die();
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    display_alert("Error");
}
