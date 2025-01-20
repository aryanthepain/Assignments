<div class="sellform">
    <h1 class="sftitle">Update Student Info</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="include/handleModify.inc.php"
            method="post"
            id="sellform">

            <div>
                <div>
                    <label class="sflabel" for="mroll">
                        Current Roll Number
                    </label>
                    <input
                        type="number"
                        min="100000000"
                        max="999999999"
                        class="sfinput"
                        required
                        id="mroll"
                        name="roll_no" />
                </div>
            </div>
            <div>
                <p class="sflabel">
                    New details(leave empty to keep unchanged):
                </p>
            </div>
            <div>
                <div>
                    <label class="sflabel" for="mfirst">
                        First Name
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        id="mfirst"
                        name="firstName" />
                </div>
            </div>

            <input type="submit" value="Update" class="sfsubmit" />
        </form>
    </div>
</div>