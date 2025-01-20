<div class="sellform">
    <h1 class="sftitle">Search Book</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="handleSelect.php"
            method="post">
            <div>

                <div>
                    <div>
                        <label class="sflabel" for="sfirst">
                            Book Name
                        </label>
                        <input
                            type="text"
                            class="sfinput"
                            id="sfirst"
                            name="firstName" />
                    </div>
                </div>

                <h3>
                    OR
                </h3>

                <div>
                    <div>
                        <label class="sflabel" for="sroll">
                            Book ID
                        </label>
                        <input
                            type="number"
                            class="sfinput"
                            id="sroll"
                            min="10000"
                            max="99999"
                            name="roll_no" />
                    </div>
                </div>



            </div>

            <input type="submit" value="Search" class="sfsubmit" />
        </form>
    </div>
</div>