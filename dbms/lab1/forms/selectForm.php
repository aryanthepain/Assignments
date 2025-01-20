<div class="sellform">
    <h1 class="sftitle">Search in the DataBase</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="handleSelect.php"
            method="post"
            id="sellform">
            <div>

                <div>
                    <div>
                        <label class="sflabel" for="sfirst">
                            First Name
                        </label>
                        <input
                            type="text"
                            class="sfinput"
                            id="sfirst"
                            name="firstName" />
                    </div>
                    <div>
                        <label class="sflabel" for="slast">
                            Last Name
                        </label>
                        <input
                            type="text"
                            class="sfinput"
                            id="slast"
                            name="lastName" />
                    </div>
                </div>

                <h3>
                    OR
                </h3>

                <div>
                    <div>
                        <label class="sflabel" for="sroll">
                            Roll Number
                        </label>
                        <input
                            type="number"
                            class="sfinput"
                            id="sroll"
                            min="1"
                            step="1"
                            name="roll_no" />
                    </div>
                </div>



            </div>

            <input type="submit" value="Search" class="sfsubmit" />
        </form>
    </div>
</div>