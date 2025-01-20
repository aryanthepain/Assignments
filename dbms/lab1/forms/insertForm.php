<div class="sellform">
    <h1 class="sftitle">Insert into the DataBase</h1>

    <div class="sfcontainer">
        <form
            class="sform"
            action="include/handleInsert.inc.php"
            method="post"
            id="sellform">
            <div>
                <div>
                    <label class="sflabel" for="ifirst">
                        First Name
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        required
                        id="ifirst"
                        name="firstName" />
                </div>
                <div>
                    <label class="sflabel" for="ilast">
                        Last Name
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        required
                        id="ilast"
                        name="lastName" />
                </div>
                <div>
                    <label class="sflabel" for="idob">
                        Date of Birth
                    </label>
                    <input
                        type="date"
                        class="sfinput"
                        required
                        id="idob"
                        name="dob" />
                </div>
            </div>
            <div>
                <div>
                    <label class="sflabel" for="ibranch">
                        Branch
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        required
                        id="ibranch"
                        name="branch" />
                </div>
                <div>
                    <label class="sflabel" for="iphone">
                        Phone Number
                    </label>
                    <input
                        type="number"
                        min="1000000000"
                        max="9999999999"
                        class="sfinput"
                        required
                        id="iphone"
                        name="phone_no" />
                </div>
                <div>
                    <label class="sflabel" for="ihostel">
                        Hostel
                    </label>
                    <input
                        type="text"
                        class="sfinput"
                        required
                        id="ihostel"
                        name="hostel" />
                </div>
            </div>
            <div>
                <div>
                    <label class="sflabel" for="icpi">
                        CPI
                    </label>
                    <input
                        type="number"
                        max="10"
                        min="0"
                        value="0"
                        step="0.01"
                        class="sfinput"
                        required
                        id="icpi"
                        name="CPI" />
                </div>
            </div>

            <input type="submit" value="Insert" class="sfsubmit" />
        </form>
    </div>
</div>