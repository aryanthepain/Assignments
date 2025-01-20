<div class="sellform">
    <h1 class="sftitle">Return Book</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="handleReturn.inc.php"
            method="get">
            <div>
                <div>
                    <label class="sflabel" for="rroll">
                        Roll Number
                    </label>
                    <input
                        type="number"
                        min="100000000"
                        max="999999999"
                        class="sfinput"
                        required
                        id="rroll"
                        name="rollNo" />
                </div>
            </div>

            <input type="submit" value="Find issued books" class="sfsubmit" />
        </form>
    </div>
</div>