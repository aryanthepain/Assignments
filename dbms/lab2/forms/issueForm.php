<div class="sellform">
    <h1 class="sftitle">Issue Book</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="include/handleIssue.inc.php"
            method="post">
            <div>
                <div>
                    <label class="sflabel" for="issueRoll">
                        Roll Number
                    </label>
                    <input
                        type="number"
                        min="100000000"
                        max="999999999"
                        class="sfinput"
                        required
                        id="issueRoll"
                        name="rollNo" />
                </div>
                <div>
                    <label class="sflabel" for="issueBook">
                        Book ID
                    </label>
                    <input
                        type="number"
                        min="10000"
                        max="99999"
                        class="sfinput"
                        required
                        id="issueBook"
                        name="bookID" />
                </div>
            </div>

            <input type="submit" value="Issue" class="sfsubmit" />
        </form>
    </div>
</div>