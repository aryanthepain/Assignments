<div class="single_search_result">
    <div
        class="sform"
        id="sellform">
        <div>
            <div>
                <div class="sflabel">
                    Roll Number:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["Roll_number"]); ?>
                </div>
            </div>
            <div>
                <div class="sflabel">
                    First Name:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["First_name"]); ?>
                </div>
            </div>
            <div>
                <div class="sflabel">
                    Last Name:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["Last_name"]); ?>
                </div>
            </div>
            <div>
                <div class="sflabel">
                    Branch:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["branch"]); ?>
                </div>
            </div>
        </div>
        <div>
            <div>
                <div class="sflabel">
                    Date of Birth:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["DOB"]); ?>
                </div>
            </div>

            <div>
                <div class="sflabel">
                    Hostel:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["Hostel"]); ?>
                </div>
            </div>
            <div>
                <div class="sflabel">
                    Phone Number:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["Phone_no"]); ?>
                </div>
            </div>
        </div>

        <div>
            <div>
                <div class="sflabel">
                    CPI:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($row["GPA"]); ?>
                </div>
            </div>
        </div>
    </div>
</div>