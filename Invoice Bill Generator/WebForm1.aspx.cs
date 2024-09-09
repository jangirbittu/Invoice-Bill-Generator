using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Invoice_Bill_Generator
{
    public partial class WebForm1 : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set the current date in the invoice date label
                Label1.Text = DateTime.Now.ToString("dd/MM/yyyy");
                TextBox1.Text = GenerateUniqueInvoiceNumber();
                Label1.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
        }
        private string GenerateUniqueInvoiceNumber()
        {
            // You can use a combination of date and time or GUID for uniqueness
            // Here is an example using date and time
            string uniqueNumber = DateTime.Now.ToString("yyyyMMddHHmmss");
            return "INV-" + uniqueNumber; // Prefix with 'INV-' to signify it's an invoice number
        }

        // Event handler for the Add Row button
        protected void AddRowButton_Click(object sender, EventArgs e)
        {
            // Create a new TableRow
            TableRow newRow = new TableRow();

            // Create and add cells to the row
            newRow.Cells.Add(CreateTextBoxCell("SNo"));
            newRow.Cells.Add(CreateTextBoxCell("ItemDesc"));
            newRow.Cells.Add(CreateTextBoxCell("Qty"));
            newRow.Cells.Add(CreateTextBoxCell("Rate"));
            newRow.Cells.Add(CreateTextBoxCell("Amount"));

            // Add the new row to the InvoiceTable
            InvoiceTable.Rows.Add(newRow);
        }

        // Helper method to create a TableCell with a TextBox
        private TableCell CreateTextBoxCell(string id)
        {
            TableCell cell = new TableCell();
            TextBox textBox = new TextBox
            {
                ID = "TextBox" + id,
                ClientIDMode = ClientIDMode.Static
            };
            cell.Controls.Add(textBox);
            return cell;
        }

        // Event handler for the Print button
        protected void PrintButton_Click(object sender, EventArgs e)
        {
            // Handle printing logic if needed. Usually, printing is done on the client side, so this may remain empty.
        }
    }
}
