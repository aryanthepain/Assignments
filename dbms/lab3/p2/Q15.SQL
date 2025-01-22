SELECT
    *
FROM
    Projects
WHERE
    ProjectID NOT IN (
        SELECT DISTINCT
            ProjectID
        FROM
            EmployeeProjects
    );