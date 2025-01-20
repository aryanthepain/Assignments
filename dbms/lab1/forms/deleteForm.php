<div class="sellform">
    <h1 class="sftitle">Delete in the DataBase</h1>

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
                            class="sfinput"
                            id="droll"
                            min="1"
                            step="1"
                            name="roll_no" />
                    </div>
                </div>

            </div>

            <input type="submit" value="Delete" class="sfsubmit" />
        </form>
    </div>
</div>