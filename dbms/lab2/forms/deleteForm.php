<div class="sellform">
    <h1 class="sftitle">Delete Student Info</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="include/handleDelete.inc.php"
            method="post"
            id="sellform">

            <div>
                <div>
                    <div>
                        <label class="sflabel" for="droll">
                            Roll Number
                        </label>
                        <input
                            type="number"
                            min="100000000"
                            max="999999999"
                            class="sfinput"
                            id="droll"
                            name="roll_no" />
                    </div>
                </div>

            </div>

            <input type="submit" value="Delete" class="sfsubmit" />
        </form>
    </div>
</div>