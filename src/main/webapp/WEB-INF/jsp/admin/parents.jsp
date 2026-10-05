<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Parent Accounts | StudentSys</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>body{font-family:Inter,Arial,sans-serif;background:#f3f7f8}.main-content-collapsed{margin-left:4rem!important}.main-content-expanded{margin-left:16rem!important}</style>
</head>
<body class="text-slate-800">
<%@ include file="sidebar.jsp" %>
<main id="mainContent" class="main-content-expanded min-h-screen p-6 md:p-8">
    <div class="mx-auto max-w-5xl">
        <p class="text-sm font-semibold text-teal-700">FAMILY ACCESS</p>
        <h1 class="mt-1 text-3xl font-bold">Parent Accounts</h1>
        <p class="mt-2 text-slate-500">Create a parent login, then securely link it to a student.</p>
        <div id="notice" class="hidden mt-5 rounded-lg px-4 py-3" role="status" aria-live="polite"></div>

        <section class="mt-7 rounded-xl border border-slate-100 bg-white p-5 shadow-sm">
            <h2 class="text-lg font-semibold">Link parent to student</h2>
            <p class="mt-1 text-sm text-slate-500">First create a user with the Parent role from User Management.</p>
            <form id="linkForm" class="mt-5 grid grid-cols-1 gap-4 md:grid-cols-3 md:items-end">
                <label class="text-sm font-medium">Student
                    <select id="studentId" required class="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5">
                        <option value="">Choose a student</option>
                        <c:forEach items="${students}" var="student">
                            <option value="${student.id}"><c:out value="${student.name}"/> — <c:out value="${student.rollNo}"/></option>
                        </c:forEach>
                    </select>
                </label>
                <label class="text-sm font-medium">Parent account email
                    <input id="parentEmail" type="email" required placeholder="parent@example.com" class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5">
                </label>
                <button id="linkButton" class="rounded-lg bg-teal-700 px-4 py-2.5 font-semibold text-white hover:bg-teal-800">Link account</button>
            </form>
        </section>

        <section class="mt-6 overflow-hidden rounded-xl border border-slate-100 bg-white shadow-sm">
            <div class="flex items-center justify-between border-b border-slate-100 p-5">
                <div><h2 class="text-lg font-semibold">Current links</h2><p class="text-sm text-slate-500">Parents can view only the students linked to their account.</p></div>
                <button type="button" onclick="loadLinks()" class="rounded-lg border border-slate-200 px-3 py-2 hover:bg-slate-50">Refresh</button>
            </div>
            <div class="overflow-x-auto"><table class="w-full min-w-[600px] text-left text-sm">
                <thead class="bg-slate-50 text-slate-500"><tr><th class="px-5 py-3">Parent</th><th class="px-5 py-3">Student</th><th class="px-5 py-3">Grade / Section</th></tr></thead>
                <tbody id="linkRows" class="divide-y divide-slate-100"><tr><td colspan="3" class="px-5 py-6 text-center text-slate-500">Loading…</td></tr></tbody>
            </table></div>
        </section>
    </div>
</main>
<script>
    function showNotice(message, error=false) {
        const node=document.getElementById("notice"); node.textContent=message;
        node.className="mt-5 rounded-lg px-4 py-3 "+(error?"bg-rose-50 text-rose-800":"bg-emerald-50 text-emerald-800");
    }
    async function request(url, options={}) {
        const response=await fetch(url,{...options,headers:{"Content-Type":"application/json",...(options.headers||{})}});
        if(!response.ok){let msg="Request failed";try{const body=await response.json();msg=body.detail||body.message||msg}catch(_){}throw new Error(msg)}
        return response.json();
    }
    function cell(row,value){const td=document.createElement("td");td.className="px-5 py-3";td.textContent=value||"—";row.appendChild(td)}
    async function loadLinks(){
        const tbody=document.getElementById("linkRows");
        try{const links=await request("/api/admin/parents/links");tbody.replaceChildren();
            if(!links.length){const tr=document.createElement("tr"),td=document.createElement("td");td.colSpan=3;td.className="px-5 py-6 text-center text-slate-500";td.textContent="No parent links yet.";tr.appendChild(td);tbody.appendChild(tr);return}
            links.forEach(link=>{const tr=document.createElement("tr");cell(tr,(link.parentName?link.parentName+" · ":"")+link.parentEmail);cell(tr,(link.studentName||"Student")+(link.rollNo?" · "+link.rollNo:""));cell(tr,[link.grade,link.section].filter(Boolean).join(" / "));tbody.appendChild(tr)})
        }catch(error){tbody.replaceChildren();const tr=document.createElement("tr"),td=document.createElement("td");td.colSpan=3;td.className="px-5 py-6 text-center text-rose-700";td.textContent=error.message;tr.appendChild(td);tbody.appendChild(tr)}
    }
    document.getElementById("linkForm").addEventListener("submit",async event=>{
        event.preventDefault();const button=document.getElementById("linkButton");button.disabled=true;
        try{await request("/api/admin/parents/links",{method:"POST",body:JSON.stringify({studentId:Number(document.getElementById("studentId").value),parentEmail:document.getElementById("parentEmail").value.trim()})});event.target.reset();showNotice("Parent account linked successfully.");await loadLinks()}
        catch(error){showNotice(error.message,true)}finally{button.disabled=false}
    });
    loadLinks();
</script>
</body>
</html>
