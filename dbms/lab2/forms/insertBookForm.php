<div class="sellform">
    <h1 class="sftitle">Insert new book</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="include/handleBookInsert.inc.php"
            method="post">
            <div>
                <div>
                    <label class="sflabel" for="ibBook">
                        Book Name
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        required
                        id="ibBook"
                        name="book" />
                </div>
                <div>
                    <label class="sflabel" for="ibID">
                        Book ID
                    </label>
                    <input
                        type="number"
                        min="10000"
                        max="99999"
                        class="sfinput"
                        required
                        id="ibID"
                        name="bid" />
                </div>
            </div>

            <input type="submit" value="Insert" class="sfsubmit" />
        </form>
    </div>
</div>