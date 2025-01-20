<div class="sellform">
    <h1 class="sftitle">Insert new student</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="include/handleStudentInsert.inc.php"
            method="post">
            <div>
                <div>
                    <label class="sflabel" for="isFirst">
                        First Name
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        required
                        id="isFirst"
                        name="firstName" />
                </div>
                <div>
                    <label class="sflabel" for="isRoll">
                        Roll Number
                    </label>
                    <input
                        type="number"
                        min="100000000"
                        max="999999999"
                        class="sfinput"
                        required
                        id="isRoll"
                        name="rollNo" />
                </div>
            </div>

            <input type="submit" value="Insert" class="sfsubmit" />
        </form>
    </div>
</div>