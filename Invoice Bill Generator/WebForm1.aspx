<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice Bill</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery UI CSS -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .invoice-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .invoice-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .invoice-footer {
            text-align: center;
            margin-bottom: 20px;
        }

        .table th,
        .table td {
            vertical-align: middle;
        }

        .btn-custom {
            margin-top: 15px;
        }

        .terms {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 20px;
        }

        /* Center-align the inputs in the invoice header */
        .invoice-header input {
            text-align: center;
        }
    </style>
    <!-- jQuery and jQuery UI -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
        $(function () {
            // Generate unique invoice number
            function generateInvoiceNumber() {
                var uniqueNumber = 'INV' + Date.now(); // Use current timestamp to ensure uniqueness
                $("#invoiceNumber").val(uniqueNumber);
            }

            generateInvoiceNumber(); // Generate invoice number on load

            // Set current date for the invoice
            $("#invoiceDate").val(new Date().toISOString().split('T')[0]);

            $("#dueDate").datepicker({ dateFormat: 'yy-mm-dd' }); // Initialize date picker

            // Add event handler for + button click
            $("#addRowButton").on("click", function (e) {
                e.preventDefault();
                var rowCount = $("#invoiceTable tbody tr").length + 1;
                var newRow = `<tr>
                    <td><input type='text' class='form-control sno' value='` + rowCount + `' readonly /></td>
                    <td><input type='text' class='form-control itemdesc' /></td>
                    <td><input type='number' class='form-control qty' /></td>
                    <td><input type='number' class='form-control rate' /></td>
                    <td><input type='text' class='form-control amount' readonly='readonly' /></td>
                </tr>`;
                $("#invoiceTable tbody").append(newRow);
            });

            // Calculate Amount and Subtotal
            function calculateTotals() {
                var subtotal = 0;
                $("#invoiceTable .amount").each(function () {
                    var amount = parseFloat($(this).val()) || 0;
                    subtotal += amount;
                });
                $("#subTotal").val(subtotal.toFixed(2));

                // Calculate Total with Tax
                var taxRate = parseFloat($("#taxRate").val()) || 0;
                var taxAmount = subtotal * (taxRate / 100);
                var total = subtotal + taxAmount;
                $("#totalAmount").val(total.toFixed(2));
            }

            // Calculate Amount on Qty or Rate change
            $(document).on("input", ".qty, .rate", function () {
                var row = $(this).closest("tr");
                var qty = parseFloat(row.find(".qty").val()) || 0;
                var rate = parseFloat(row.find(".rate").val()) || 0;
                var amount = qty * rate;
                row.find(".amount").val(amount.toFixed(2));
                calculateTotals();
            });

            // Recalculate Total on Tax Rate change
            $("#taxRate").on("input", function () {
                calculateTotals();
            });

            // Add event handler for print button click
            $("#printButton").on("click", function () {
                window.print();
            });
        });
    </script>
</head>
<body>

    <div class="container invoice-container">
        <h3 class="text-center mt-4">Invoice</h3>
        <div class="invoice-header">
            <h2><input type="text" class="form-control" placeholder="Company Name"></h2>
            <p><input type="text" class="form-control" placeholder="Address of Company"></p>
        </div>

        <div class="form-group row">
            <label class="col-sm-2 col-form-label">Invoice</label>
            <div class="col-sm-10">
                <input type="text" id="invoiceNumber" class="form-control" readonly />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label">Invoice Date</label>
            <div class="col-sm-10">
                <input type="text" id="invoiceDate" class="form-control" readonly />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label">Terms</label>
            <div class="col-sm-10">
                <input type="text" id="terms" class="form-control" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label">Due Date</label>
            <div class="col-sm-10">
                <input type="text" id="dueDate" class="form-control" />
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <h5>Bill To</h5>
                <textarea id="billTo" class="form-control"></textarea>
            </div>
            <div class="col-md-6">
                <h5>Ship To</h5>
                <textarea id="shipTo" class="form-control"></textarea>
            </div>
        </div>

        <table class="table table-bordered mt-3" id="invoiceTable">
            <thead class="thead-light">
                <tr>
                    <th>S No.</th>
                    <th>Item & Description</th>
                    <th>Qty</th>
                    <th>Rate</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><input type="text" class="form-control sno" value="1" readonly /></td>
                    <td><input type="text" class="form-control itemdesc" /></td>
                    <td><input type="number" class="form-control qty" /></td>
                    <td><input type="number" class="form-control rate" /></td>
                    <td><input type="text" class="form-control amount" readonly /></td>
                </tr>
            </tbody>
        </table>

        <div class="row">
            <div class="col-md-6 offset-md-6">
                <table class="table">
                    <tr>
                        <td>Sub Total</td>
                        <td><input type="text" id="subTotal" class="form-control" readonly /></td>
                    </tr>
                    <tr>
                        <td>Tax Rate (%)</td>
                        <td><input type="text" id="taxRate" class="form-control" /></td>
                    </tr>
                    <tr>
                        <td>Total</td>
                        <td><input type="text" id="totalAmount" class="form-control" readonly /></td>
                    </tr>
                </table>
            </div>
        </div>

        <p class="terms">
            <strong>Terms & Conditions:</strong> Full payment is due upon receipt of this invoice. Late payments may incur additional charges or interest as per applicable laws.
        </p>

        <div class="text-center">
            <button id="addRowButton" class="btn btn-primary btn-sm btn-custom">Add Item</button>
            <button id="printButton" class="btn btn-success btn-sm btn-custom">Print</button>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
