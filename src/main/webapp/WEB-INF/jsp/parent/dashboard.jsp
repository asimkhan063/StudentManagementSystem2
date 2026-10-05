<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Parent Portal | StudentSys</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>body{font-family:Inter,Arial,sans-serif;background:#f3f7f8}</style>
</head>
<body class="min-h-screen text-slate-800">
<header class="flex items-center justify-between bg-white px-5 py-4 shadow-sm md:px-10">
    <div><p class="text-sm font-semibold text-teal-700">STUDENTSYS</p><h1 class="text-xl font-bold">Parent Portal</h1></div>
    <form action="${pageContext.request.contextPath}/logout" method="post"><button class="rounded-lg border border-slate-200 px-4 py-2 hover:bg-slate-50">Logout</button></form>
</header>
<main class="mx-auto max-w-6xl p-5 md:p-10">
    <h2 class="text-2xl font-bold">Your linked students</h2>
    <p class="mt-2 text-slate-500">Attendance and fee information is shown only for students linked to your account.</p>
    <div id="children" class="mt-6 grid grid-cols-1 gap-5"></div>
</main>
<script>
    const money = new Intl.NumberFormat("en-IN", {style: "currency", currency: "INR"});
    const container = document.getElementById("children");

    function el(tag, text, className) {
        const node = document.createElement(tag);
        if (text !== null && text !== undefined) node.textContent = text;
        if (className) node.className = className;
        return node;
    }

    function sectionTable(title, headers, rows) {
        const section = el("section", null, "mt-5");
        section.appendChild(el("h4", title, "mb-2 font-semibold text-slate-700"));
        if (!rows.length) {
            section.appendChild(el("p", "No records available.", "rounded-lg bg-slate-50 p-3 text-sm text-slate-500"));
            return section;
        }
        const wrapper = el("div", null, "overflow-x-auto rounded-lg border border-slate-200");
        const table = el("table", null, "min-w-full text-left text-sm");
        const thead = document.createElement("thead");
        const headerRow = document.createElement("tr");
        headers.forEach(header => headerRow.appendChild(el("th", header, "bg-slate-50 px-3 py-2 font-medium")));
        thead.appendChild(headerRow);
        const tbody = document.createElement("tbody");
        rows.forEach(values => {
            const row = document.createElement("tr");
            values.forEach(value => row.appendChild(el("td", value ?? "—", "border-t border-slate-100 px-3 py-2")));
            tbody.appendChild(row);
        });
        table.append(thead, tbody);
        wrapper.appendChild(table);
        section.appendChild(wrapper);
        return section;
    }

    function renderStudent(student) {
        const card = el("article", null, "rounded-xl border border-slate-100 bg-white p-5 shadow-sm md:p-6");
        card.appendChild(el("h3", student.name, "text-lg font-semibold"));
        card.appendChild(el("p", [student.rollNo ? "Roll " + student.rollNo : null,
            student.grade ? "Grade " + student.grade : null,
            student.section ? "Section " + student.section : null].filter(Boolean).join(" · "), "mt-1 text-sm text-slate-500"));
        const attendanceRows = (student.attendance || []).map(item => [item.date, item.grade + "-" + item.section, item.status]);
        card.appendChild(sectionTable("Recent attendance", ["Date", "Class", "Status"], attendanceRows));
        const feeRows = (student.invoices || []).map(invoice => [invoice.title, invoice.dueDate,
            money.format(invoice.totalAmount), money.format(invoice.paidAmount), money.format(invoice.balance), invoice.status]);
        card.appendChild(sectionTable("Fee invoices", ["Invoice", "Due date", "Total", "Paid", "Balance", "Status"], feeRows));
        (student.invoices || []).filter(invoice => invoice.balance > 0).forEach(invoice => {
            const pay = el("button", `Pay ${money.format(invoice.balance)} · ${invoice.title}`, "mt-2 mr-2 rounded-lg bg-teal-700 px-4 py-2 text-sm font-semibold text-white hover:bg-teal-800");
            pay.type = "button";
            pay.onclick = () => payInvoice(invoice.invoiceId, invoice.title, student.name);
            card.appendChild(pay);
        });
        const report = student.reportCard || {};
        card.appendChild(el("h4", "Report card and learning", "mt-5 mb-2 font-semibold text-slate-700"));
        card.appendChild(el("p", `Quiz average: ${report.averageQuizPercentage ?? 0}% · Assignments: ${report.assignmentsSubmitted ?? 0} submitted, ${report.assignmentsGraded ?? 0} graded${report.averageAssignmentScore == null ? "" : " · Assignment average: " + report.averageAssignmentScore + "%"}`, "rounded-lg bg-teal-50 p-3 text-sm text-teal-900"));
        const quizRows = (report.quizzes || []).map(result => [result.quizTitle, `${result.score}/${result.maxScore}`, `${result.percentage}%`, result.submittedAt]);
        card.appendChild(sectionTable("Quiz results", ["Quiz", "Score", "Percent", "Submitted"], quizRows));
        container.appendChild(card);
    }

    async function payInvoice(invoiceId, title, studentName) {
        try {
            const orderResponse = await fetch(`${pageContext.request.contextPath}/api/parent/payments/invoices/${invoiceId}/order`, {method: "POST"});
            if (!orderResponse.ok) throw new Error(await orderResponse.text());
            const order = await orderResponse.json();
            const checkout = new Razorpay({
                key: order.keyId, amount: order.amount, currency: order.currency,
                name: order.schoolName, description: `${studentName} · ${title}`, order_id: order.orderId,
                handler: async function (response) {
                    const verified = await fetch(`${pageContext.request.contextPath}/api/parent/payments/verify`, {
                        method: "POST", headers: {"Content-Type": "application/json"},
                        body: JSON.stringify({razorpayOrderId: response.razorpay_order_id,
                            razorpayPaymentId: response.razorpay_payment_id, razorpaySignature: response.razorpay_signature})
                    });
                    if (!verified.ok) throw new Error(await verified.text());
                    alert("Payment verified and recorded.");
                    loadChildren();
                },
                modal: {ondismiss: function () { loadChildren(); }}
            });
            checkout.on("payment.failed", function (event) {
                alert("Payment did not complete. Please try again or contact the school office.");
                console.error("Razorpay payment failed", event.error && event.error.code);
            });
            checkout.open();
        } catch (error) {
            alert(error.message || "Online payment could not be started.");
        }
    }

    async function loadChildren() {
        try {
            const response = await fetch("${pageContext.request.contextPath}/api/parent/children", {
                headers: {"Accept": "application/json"}
            });
            if (!response.ok) throw new Error("Could not load linked student information. Please sign in again or contact the school administrator.");
            const students = await response.json();
            container.replaceChildren();
            if (!students.length) {
                container.appendChild(el("div", "No student is linked to your account yet. Please contact the school administrator.",
                    "rounded-xl bg-white p-6 text-slate-600 shadow-sm"));
                return;
            }
            students.forEach(renderStudent);
        } catch (error) {
            container.replaceChildren(el("div", error.message, "rounded-xl bg-rose-50 p-6 text-rose-800"));
        }
    }
    loadChildren();
</script>
</body>
</html>
