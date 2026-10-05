// API URL
const apiBaseUrl = `${window.location.origin}/students`;

// Get HTML elements
const studentForm = document.getElementById("studentForm");
const editStudentForm = document.getElementById("editStudentForm");
const studentTable = document.querySelector("#studentTable tbody");

const studentModal = document.getElementById("studentModal");
const editStudentModal = document.getElementById("editStudentModal");

const openModalButton = document.getElementById("openModalButton");
const closeModalButton = document.getElementById("closeModalButton");
const closeEditModalButton = document.getElementById("closeEditModalButton");

// Open Add Student Form
if (openModalButton) {
openModalButton.addEventListener("click", function () {
studentForm.reset();
studentForm.dataset.mode = "add";
delete studentForm.dataset.id;

```
    studentModal.style.display = "block";
});
```

}

// Close Add Student Form
if (closeModalButton) {
closeModalButton.addEventListener("click", function () {
studentModal.style.display = "none";
studentForm.reset();
});
}

// Close Edit Student Form
if (closeEditModalButton) {
closeEditModalButton.addEventListener("click", function () {
editStudentModal.style.display = "none";
});
}

// Close modal when clicking outside
window.addEventListener("click", function (event) {
if (event.target === studentModal) {
studentModal.style.display = "none";
}

```
if (event.target === editStudentModal) {
    editStudentModal.style.display = "none";
}
```

});

// Fetch and display all students
async function fetchStudents() {
if (!studentTable) return;

```
try {
    const response = await fetch(apiBaseUrl);

    if (!response.ok) {
        throw new Error("Failed to fetch students");
    }

    const students = await response.json();

    studentTable.innerHTML = "";

    students.forEach(function (student) {
        addStudentRow(student);
    });

} catch (error) {
    console.error("Error fetching students:", error);
}
```

}

// Add student row to table
function addStudentRow(student) {
const row = document.createElement("tr");

```
const photoCell = document.createElement("td");
const photo = document.createElement("img");

photo.className = "student-photo";
photo.alt = "Student Photo";
photo.src = student.photoPath
    ? student.photoPath
    : createPlaceholder(student.name);

photo.onerror = function () {
    photo.src = createPlaceholder(student.name);
    photo.onerror = null;
};

photoCell.appendChild(photo);
row.appendChild(photoCell);

const values = [
    student.id,
    student.name,
    student.email,
    student.grade,
    student.address,
    student.rollNo,
    student.fatherName,
    student.motherName,
    student.aadhaarNo,
    student.phoneNo,
    student.altPhoneNo,
    student.gender,
    student.section,
    student.sessionId
];

values.forEach(function (value) {
    const cell = document.createElement("td");
    cell.textContent = value ?? "";
    row.appendChild(cell);
});

const actionsCell = document.createElement("td");
actionsCell.className = "actions";

const editButton = document.createElement("button");
editButton.type = "button";
editButton.textContent = "Edit";
editButton.addEventListener("click", function () {
    openEditModal(student.id);
});

const deleteButton = document.createElement("button");
deleteButton.type = "button";
deleteButton.textContent = "Delete";
deleteButton.addEventListener("click", function () {
    deleteStudent(student.id);
});

actionsCell.appendChild(editButton);
actionsCell.appendChild(deleteButton);
row.appendChild(actionsCell);

studentTable.appendChild(row);
```

}

// Create placeholder photo
function createPlaceholder(name) {
const firstLetter = (name || "S").charAt(0).toUpperCase();

```
const canvas = document.createElement("canvas");
canvas.width = 100;
canvas.height = 100;

const context = canvas.getContext("2d");

context.fillStyle = "#0d9488";
context.fillRect(0, 0, 100, 100);

context.fillStyle = "#ffffff";
context.font = "bold 50px Arial";
context.textAlign = "center";
context.textBaseline = "middle";
context.fillText(firstLetter, 50, 50);

return canvas.toDataURL("image/png");
```

}

// Add or update student
if (studentForm) {
studentForm.addEventListener("submit", async function (event) {
event.preventDefault();

```
    const formData = new FormData(studentForm);
    const isEditing = studentForm.dataset.mode === "edit";
    const studentId = studentForm.dataset.id;

    const url = isEditing
        ? `${apiBaseUrl}/${studentId}`
        : apiBaseUrl;

    const method = isEditing ? "PUT" : "POST";

    try {
        const response = await fetch(url, {
            method: method,
            body: formData
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error("Server response:", errorText);
            throw new Error("Unable to save student. HTTP " + response.status);
        }

        alert(
            isEditing
                ? "Student updated successfully!"
                : "Student added successfully!"
        );

        studentModal.style.display = "none";
        studentForm.reset();
        studentForm.dataset.mode = "add";
        delete studentForm.dataset.id;

        await fetchStudents();

    } catch (error) {
        console.error("Error saving student:", error);
        alert(error.message || "Failed to save student.");
    }
});
```

}

// Open Edit Student Form
async function openEditModal(id) {
    try {
        const response = await fetch(`${apiBaseUrl}/${id}`);

        if (!response.ok) {
            throw new Error("Student not found");
        }

        const student = await response.json();

        const fields = [
            "name", "email", "grade", "address", "rollNo",
            "fatherName", "motherName", "aadhaarNo", "phoneNo",
            "altPhoneNo", "gender", "section", "sessionId"
        ];

        fields.forEach(function (field) {
            const input = document.getElementById("edit" +
                field.charAt(0).toUpperCase() + field.slice(1));

            if (input) {
                input.value = student[field] ?? "";
            }
        });

        document.getElementById("editStudentId").value = student.id;
        editStudentModal.style.display = "block";

    } catch (error) {
        console.error(error);
        alert("Unable to load student details.");
    }
}
/**async function openEditModal(id) {
try {
const response = await fetch(`${apiBaseUrl}/${id}`);

```
    if (!response.ok) {
        throw new Error("Student not found");
    }

    const student = await response.json();

    if (!editStudentForm || !editStudentModal) {
        window.location.href = `addoreditstudent?id=${id}`;
        return;
    }

    editStudentForm.reset();

    const fields = [
        "name",
        "email",
        "grade",
        "address",
        "rollNo",
        "fatherName",
        "motherName",
        "aadhaarNo",
        "phoneNo",
        "altPhoneNo",
        "gender",
        "section",
        "sessionId"
    ];

    fields.forEach(function (field) {
        const input = editStudentForm.elements.namedItem(field);

        if (input) {
            input.value = student[field] ?? "";
        }
    });

    document.getElementById("editStudentId").value = student.id;

    editStudentModal.style.display = "block";

} catch (error) {
    console.error("Error loading student:", error);
    alert("Unable to load student details.");
}**/
```

}

// Update student
if (editStudentForm) {
editStudentForm.addEventListener("submit", async function (event) {
event.preventDefault();

```
    const studentId = document.getElementById("editStudentId").value;
    const formData = new FormData(editStudentForm);

    try {
        const response = await fetch(`${apiBaseUrl}/${studentId}`, {
            method: "PUT",
            body: formData
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error("Server response:", errorText);
            throw new Error("Unable to update student. HTTP " + response.status);
        }

        alert("Student updated successfully!");

        editStudentModal.style.display = "none";
        await fetchStudents();

    } catch (error) {
        console.error("Error updating student:", error);
        alert(error.message || "Failed to update student.");
    }
});
```

}

// Delete student
async function deleteStudent(id) {
if (!confirm("Are you sure you want to delete this student?")) {
return;
}

```
try {
    const response = await fetch(`${apiBaseUrl}/${id}`, {
        method: "DELETE"
    });

    if (!response.ok) {
        throw new Error("Unable to delete student.");
    }

    alert("Student deleted successfully!");
    await fetchStudents();

} catch (error) {
    console.error("Error deleting student:", error);
    alert(error.message || "Failed to delete student.");
}
```

}

// Load students when page opens
document.addEventListener("DOMContentLoaded", function () {
fetchStudents();
});
