<div class="sellform">
    <h1 class="sftitle">Modify the DataBase</h1>

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
                        type="text"
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
                <div>
                    <label class="sflabel" for="mlast">
                        Last Name
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        id="mlast"
                        name="lastName" />
                </div>
                <div>
                    <label class="sflabel" for="mdob">
                        Date of Birth
                    </label>
                    <input
                        type="date"
                        class="sfinput"
                        id="mdob"
                        name="dob" />
                </div>
            </div>
            <div>
                <div>
                    <label class="sflabel" for="mbranch">
                        Branch
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        id="mbranch"
                        name="branch" />
                </div>
                <div>
                    <label class="sflabel" for="mphone">
                        Phone Number
                    </label>
                    <input
                        type="number"
                        min="1000000000"
                        max="9999999999"
                        class="sfinput"
                        id="mphone"
                        name="phone_no" />
                </div>
                <div>
                    <label class="sflabel" for="mhostel">
                        Hostel
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        id="mhostel"
                        name="hostel" />
                </div>
            </div>
            <div>
                <div>
                    <label class="sflabel" for="mcpi">
                        CPI
                    </label>
                    <input
                        type="number"
                        max="10"
                        min="0"
                        step="0.01"
                        class="sfinput"
                        id="mcpi"
                        name="CPI" />
                </div>
            </div>

            <input type="submit" value="Update" class="sfsubmit" />
        </form>
    </div>
</div>