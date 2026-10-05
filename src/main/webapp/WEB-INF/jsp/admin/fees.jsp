<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Fees Management | StudentSys</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: Inter, sans-serif; background: #f3f7f8; }
        .main-content-collapsed { margin-left: 4rem !important; }
        .main-content-expanded { margin-left: 16rem !important; }
        .fee-sidebar { width: 16rem; }
        @media (max-width: 760px) {
            #sidebar { width: 4.5rem !important; padding: 1rem !important; }
            #sidebarTitle, #menuItems { display: none; }
            #mainContent { margin-left: 4.5rem !important; padding: 1rem !important; }
        }
        #notice { display:none; }
    </style>
</head>
<body class="text-slate-800">
<%@ include file="sidebar.jsp" %>
<main id="mainContent" class="ml-64 p-8 min-h-screen">
    <div class="max-w-7xl mx-auto">
        <header class="flex flex-wrap items-center justify-between gap-4 mb-8">
            <div>
                <p class="text-sm font-semibold text-teal-700">SCHOOL FINANCE</p>
                <h1 class="text-3xl md:text-4xl font-bold mt-1">Fees Management</h1>
                <p class="text-slate-500 mt-2">Create student invoices, track balances, and record payments.</p>
            </div>
            <button onclick="loadInvoices()" class="rounded-lg bg-white border border-slate-200 px-4 py-2.5 font-medium hover:bg-slate-50">Refresh</button>
        </header>

        <div id="notice" role="status" aria-live="polite" class="mb-5 rounded-lg px-4 py-3"></div>

        <section class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-7" aria-label="Fee summary">
            <article class="rounded-xl bg-white p-5 shadow-sm border border-slate-100">
                <p class="text-sm text-slate-500">Invoices shown</p><p id="invoiceCount" class="text-3xl font-bold mt-2">—</p>
            </article>
            <article class="rounded-xl bg-white p-5 shadow-sm border border-slate-100">
                <p class="text-sm text-slate-500">Collected (shown)</p><p id="collectedTotal" class="text-3xl font-bold mt-2 text-emerald-700">—</p>
            </article>
            <article class="rounded-xl bg-white p-5 shadow-sm border border-slate-100">
                <p class="text-sm text-slate-500">Outstanding (shown)</p><p id="outstandingTotal" class="text-3xl font-bold mt-2 text-amber-700">—</p>
            </article>
        </section>

        <section class="grid grid-cols-1 xl:grid-cols-3 gap-6 items-start">
            <div class="xl:col-span-2 rounded-xl bg-white shadow-sm border border-slate-100 overflow-hidden">
                <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                    <div><h2 class="text-lg font-semibold">Fee invoices</h2><p class="text-sm text-slate-500">Latest 50 invoices, ordered by due date</p></div>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm min-w-[760px]">
                        <thead class="bg-slate-50 text-slate-500"><tr>
                            <th class="px-4 py-3 font-medium">Student / Invoice</th><th class="px-4 py-3 font-medium">Due</th>
                            <th class="px-4 py-3 font-medium">Total</th><th class="px-4 py-3 font-medium">Paid</th>
                            <th class="px-4 py-3 font-medium">Balance</th><th class="px-4 py-3 font-medium">Status</th><th class="px-4 py-3"></th>
                        </tr></thead>
                        <tbody id="invoiceRows" class="divide-y divide-slate-100"><tr><td colspan="7" class="px-4 py-8 text-center text-slate-500">Loading invoices…</td></tr></tbody>
                    </table>
                </div>
            </div>

            <div class="space-y-6">
                <section class="rounded-xl bg-white shadow-sm border border-slate-100 p-5">
                    <h2 class="text-lg font-semibold">Create invoice</h2>
                    <p class="text-sm text-slate-500 mt-1 mb-4">Add a fee amount and due date for a student.</p>
                    <form id="invoiceForm" class="space-y-4">
                        <label class="block text-sm font-medium">Student
                            <select id="studentId" required class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 bg-white">
                                <option value="">Choose a student</option>
                                <c:forEach items="${students}" var="student">
                                    <option value="${student.id}"><c:out value="${student.name}"/> — <c:out value="${student.rollNo}"/></option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="block text-sm font-medium">Fee title
                            <input id="feeTitle" required maxlength="120" placeholder="e.g. Term 1 tuition" class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5">
                        </label>
                        <label class="block text-sm font-medium">Amount (₹)
                            <input id="feeAmount" required type="number" min="0.01" step="0.01" placeholder="25000.00" class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5">
                        </label>
                        <label class="block text-sm font-medium">Due date
                            <input id="dueDate" required type="date" class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5">
                        </label>
                        <button id="createInvoiceButton" class="w-full rounded-lg bg-teal-700 px-4 py-2.5 font-semibold text-white hover:bg-teal-800">Create invoice</button>
                    </form>
                </section>

                <section class="rounded-xl bg-white shadow-sm border border-slate-100 p-5">
                    <h2 class="text-lg font-semibold">Record payment</h2>
                    <p id="paymentHint" class="text-sm text-slate-500 mt-1 mb-4">Choose “Receive” on an invoice to start.</p>
                    <form id="paymentForm" class="space-y-4">
                        <input id="paymentInvoiceId" type="hidden">
                        <label class="block text-sm font-medium">Amount (₹)
                            <input id="paymentAmount" required type="number" min="0.01" step="0.01" placeholder="Enter received amount" class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5">
                        </label>
                        <label class="block text-sm font-medium">Method
                            <select id="paymentMethod" required class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 bg-white">
                                <option value="UPI">UPI</option><option value="CASH">Cash</option><option value="CARD">Card</option><option value="BANK_TRANSFER">Bank transfer</option>
                            </select>
                        </label>
                        <label class="block text-sm font-medium">Receipt/reference (optional)
                            <input id="receiptReference" maxlength="80" class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5">
                        </label>
                        <button id="recordPaymentButton" disabled class="w-full rounded-lg bg-slate-300 px-4 py-2.5 font-semibold text-white disabled:cursor-not-allowed">Record payment</button>
                    </form>
                </section>
            </div>
        </section>
    </div>
</main>

<script>
    const money = new Intl.NumberFormat("en-IN", { style: "currency", currency: "INR" });

    function showNotice(message, isError = false) {
        const notice = document.getElementById("notice");
        notice.textContent = message;
        notice.className = "mb-5 rounded-lg px-4 py-3 " + (isError ? "bg-rose-50 text-rose-800" : "bg-emerald-50 text-emerald-800");
        notice.style.display = "block";
    }

    async function apiRequest(url, options = {}) {
        const response = await fetch(url, { ...options, headers: { "Content-Type": "application/json", ...(options.headers || {}) } });
        if (!response.ok) {
            let message = "Request failed. Please try again.";
            try { const body = await response.json(); message = body.detail || body.message || message; } catch (_) { }
            throw new Error(message);
        }
        return response.status === 204 ? null : response.json();
    }

    function addCell(row, text) {
        const cell = document.createElement("td");
        cell.className = "px-4 py-3";
        cell.textContent = text;
        row.appendChild(cell);
        return cell;
    }

    async function loadInvoices() {
        const tbody = document.getElementById("invoiceRows");
        try {
            const page = await apiRequest("/api/admin/fees/invoices?page=0&size=50");
            tbody.replaceChildren();
            let collected = 0, outstanding = 0;
            page.content.forEach(invoice => {
                collected += Number(invoice.paidAmount);
                outstanding += Number(invoice.balance);
                const row = document.createElement("tr");
                const studentCell = document.createElement("td");
                studentCell.className = "px-4 py-3";
                const studentName = document.createElement("div");
                studentName.className = "font-semibold";
                studentName.textContent = invoice.studentName || "Student";
                const subtitle = document.createElement("div");
                subtitle.className = "text-xs text-slate-500 mt-1";
                subtitle.textContent = (invoice.rollNo ? "Roll " + invoice.rollNo + " · " : "") + invoice.title;
                studentCell.append(studentName, subtitle); row.appendChild(studentCell);
                addCell(row, invoice.dueDate);
                addCell(row, money.format(invoice.totalAmount));
                addCell(row, money.format(invoice.paidAmount));
                addCell(row, money.format(invoice.balance));
                const statusCell = addCell(row, invoice.status);
                statusCell.className += " font-semibold " + (invoice.status === "PAID" ? "text-emerald-700" : invoice.status === "PARTIAL" ? "text-amber-700" : "text-rose-700");
                const actionCell = document.createElement("td"); actionCell.className = "px-4 py-3";
                if (invoice.balance > 0) {
                    const receiveButton = document.createElement("button");
                    receiveButton.type = "button"; receiveButton.textContent = "Receive";
                    receiveButton.className = "rounded-md bg-teal-700 px-3 py-1.5 text-white hover:bg-teal-800";
                    receiveButton.onclick = () => selectInvoice(invoice);
                    actionCell.appendChild(receiveButton);
                }
                row.appendChild(actionCell); tbody.appendChild(row);
            });
            if (!page.content.length) {
                const row = document.createElement("tr"), cell = document.createElement("td");
                cell.colSpan = 7; cell.className = "px-4 py-8 text-center text-slate-500"; cell.textContent = "No invoices yet. Create the first one here.";
                row.appendChild(cell); tbody.appendChild(row);
            }
            document.getElementById("invoiceCount").textContent = page.totalElements;
            document.getElementById("collectedTotal").textContent = money.format(collected);
            document.getElementById("outstandingTotal").textContent = money.format(outstanding);
        } catch (error) {
            tbody.replaceChildren();
            const row = document.createElement("tr"), cell = document.createElement("td");
            cell.colSpan = 7; cell.className = "px-4 py-8 text-center text-rose-700"; cell.textContent = error.message;
            row.appendChild(cell); tbody.appendChild(row);
        }
    }

    function selectInvoice(invoice) {
        document.getElementById("paymentInvoiceId").value = invoice.invoiceId;
        document.getElementById("paymentHint").textContent = invoice.studentName + " — remaining " + money.format(invoice.balance);
        const amount = document.getElementById("paymentAmount");
        amount.max = invoice.balance;
        amount.placeholder = "Up to " + Number(invoice.balance).toFixed(2);
        document.getElementById("recordPaymentButton").disabled = false;
        document.getElementById("recordPaymentButton").className = "w-full rounded-lg bg-teal-700 px-4 py-2.5 font-semibold text-white hover:bg-teal-800";
        amount.focus();
    }

    document.getElementById("invoiceForm").addEventListener("submit", async event => {
        event.preventDefault();
        const button = document.getElementById("createInvoiceButton"); button.disabled = true;
        try {
            await apiRequest("/api/admin/fees/invoices", { method: "POST", body: JSON.stringify({
                studentId: Number(document.getElementById("studentId").value),
                title: document.getElementById("feeTitle").value.trim(),
                totalAmount: Number(document.getElementById("feeAmount").value),
                dueDate: document.getElementById("dueDate").value
            }) });
            event.target.reset(); showNotice("Invoice created successfully."); await loadInvoices();
        } catch (error) { showNotice(error.message, true); }
        finally { button.disabled = false; }
    });

    document.getElementById("paymentForm").addEventListener("submit", async event => {
        event.preventDefault();
        const button = document.getElementById("recordPaymentButton");
        if (button.disabled) return;
        button.disabled = true;
        try {
            const invoiceId = document.getElementById("paymentInvoiceId").value;
            await apiRequest("/api/admin/fees/invoices/" + encodeURIComponent(invoiceId) + "/payments", { method: "POST", body: JSON.stringify({
                amount: Number(document.getElementById("paymentAmount").value),
                paymentMethod: document.getElementById("paymentMethod").value,
                receiptReference: document.getElementById("receiptReference").value.trim() || null
            }) });
            event.target.reset(); document.getElementById("paymentInvoiceId").value = "";
            document.getElementById("paymentHint").textContent = "Choose “Receive” on an invoice to start.";
            showNotice("Payment recorded successfully."); await loadInvoices();
        } catch (error) { showNotice(error.message, true); button.disabled = false; }
    });

    loadInvoices();
</script>
</body>
</html>
