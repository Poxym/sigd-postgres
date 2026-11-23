-- SIGD / modelo relacional v1 / propuesta trazable al 22-11-2026

BEGIN;

CREATE TABLE "universities" (
  "id" text PRIMARY KEY,
  "name" text NOT NULL
);

CREATE TABLE "campuses" (
  "id" text PRIMARY KEY,
  "university_id" text NOT NULL,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "careers" (
  "id" text PRIMARY KEY,
  "campus_id" text NOT NULL,
  "predecessor_id" text,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "study_plans" (
  "id" text PRIMARY KEY,
  "career_id" text NOT NULL,
  "created_by" text NOT NULL,
  "name" text NOT NULL,
  "semesters" integer NOT NULL,
  "registered_at" timestamptz NOT NULL,
  "active" boolean NOT NULL
);

CREATE TABLE "curriculum_semesters" (
  "id" text PRIMARY KEY,
  "study_plan_id" text NOT NULL,
  "number" integer NOT NULL,
  UNIQUE ("study_plan_id", "number")
);

CREATE TABLE "subjects" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "credits" numeric NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "curriculum_subjects" (
  "id" text PRIMARY KEY,
  "semester_id" text NOT NULL,
  "subject_id" text NOT NULL,
  UNIQUE ("semester_id", "subject_id")
);

CREATE TABLE "periods" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "start" date NOT NULL,
  "end" date NOT NULL,
  "effective_weeks" numeric NOT NULL,
  "nominal_weekly_minutes" numeric NOT NULL,
  "maximum_weekly_minutes" numeric NOT NULL,
  "enforce_maximum" boolean NOT NULL,
  "rejection_threshold" numeric NOT NULL,
  "state" text NOT NULL,
  "catalog_id" text,
  UNIQUE ("code")
);

CREATE TABLE "capture_windows" (
  "id" text PRIMARY KEY,
  "period_id" text NOT NULL,
  "kind" text NOT NULL,
  "opens_at" timestamptz NOT NULL,
  "closes_at" timestamptz NOT NULL,
  "enabled" boolean NOT NULL,
  UNIQUE ("period_id", "kind")
);

CREATE TABLE "groups" (
  "id" text PRIMARY KEY,
  "period_id" text NOT NULL,
  "campus_id" text NOT NULL,
  "semester_id" text,
  "code" text NOT NULL,
  "kind" text NOT NULL,
  "capacity" integer NOT NULL,
  UNIQUE ("period_id", "campus_id", "code")
);

CREATE TABLE "course_offerings" (
  "id" text PRIMARY KEY,
  "group_id" text NOT NULL,
  "subject_id" text NOT NULL,
  UNIQUE ("group_id", "subject_id")
);

CREATE TABLE "teaching_assignments" (
  "id" text PRIMARY KEY,
  "offering_id" text NOT NULL,
  "teacher_id" text NOT NULL,
  "previous_id" text,
  "start" date NOT NULL,
  "end" date,
  "weekly_minutes" numeric NOT NULL,
  "students" integer NOT NULL,
  "change_reason" text
);

CREATE TABLE "users" (
  "id" text PRIMARY KEY,
  "auth_uid" text,
  "employee_number" text NOT NULL,
  "first_name" text NOT NULL,
  "last_name" text NOT NULL,
  "second_last_name" text,
  "email" text NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("employee_number"),
  UNIQUE ("email"),
  UNIQUE ("auth_uid")
);

CREATE TABLE "employee_history" (
  "id" text PRIMARY KEY,
  "user_id" text NOT NULL,
  "employee_number" text NOT NULL,
  "start" date NOT NULL,
  "end" date
);

CREATE TABLE "degrees" (
  "id" text PRIMARY KEY,
  "user_id" text NOT NULL,
  "level" text NOT NULL,
  "program" text NOT NULL,
  "institution" text NOT NULL,
  "obtained_on" date NOT NULL,
  "license" text,
  "official" boolean NOT NULL,
  "maximum" boolean NOT NULL
);

CREATE TABLE "teacher_categories" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "level" text NOT NULL,
  "researcher" boolean NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "teachers" (
  "id" text PRIMARY KEY,
  "user_id" text NOT NULL,
  "category_id" text NOT NULL,
  "joined_on" date NOT NULL,
  UNIQUE ("user_id")
);

CREATE TABLE "affiliations" (
  "id" text PRIMARY KEY,
  "teacher_id" text NOT NULL,
  "career_id" text NOT NULL,
  "start" date NOT NULL,
  "end" date
);

CREATE TABLE "distinctions" (
  "id" text PRIMARY KEY,
  "teacher_id" text NOT NULL,
  "name" text NOT NULL,
  "level" text,
  "start" date NOT NULL,
  "end" date
);

CREATE TABLE "roles" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "permissions" (
  "id" text PRIMARY KEY,
  "resource" text NOT NULL,
  "action" text NOT NULL,
  UNIQUE ("resource", "action")
);

CREATE TABLE "role_permissions" (
  "id" text PRIMARY KEY,
  "role_id" text NOT NULL,
  "permission_id" text NOT NULL,
  UNIQUE ("role_id", "permission_id")
);

CREATE TABLE "role_assignments" (
  "id" text PRIMARY KEY,
  "user_id" text NOT NULL,
  "role_id" text NOT NULL,
  "campus_id" text,
  "career_id" text,
  "start" date NOT NULL,
  "end" date
);

CREATE TABLE "approval_delegations" (
  "id" text PRIMARY KEY,
  "career_id" text NOT NULL,
  "user_id" text NOT NULL,
  "assigned_by" text NOT NULL,
  "start" date NOT NULL,
  "end" date NOT NULL,
  "reason" text NOT NULL
);

CREATE TABLE "audit_events" (
  "id" text PRIMARY KEY,
  "actor_id" text NOT NULL,
  "at" timestamptz NOT NULL,
  "action" text NOT NULL,
  "entity" text NOT NULL,
  "record_id" text NOT NULL,
  "before" jsonb,
  "after" jsonb
);

CREATE TABLE "notifications" (
  "id" text PRIMARY KEY,
  "user_id" text NOT NULL,
  "document_id" text,
  "at" timestamptz NOT NULL,
  "title" text NOT NULL,
  "body" text NOT NULL,
  "read_at" timestamptz
);

CREATE TABLE "rubrics" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "axis" text NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "activities" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "activity_classifications" (
  "id" text PRIMARY KEY,
  "activity_id" text NOT NULL,
  "rubric_id" text NOT NULL,
  "start" date NOT NULL,
  "end" date
);

CREATE TABLE "field_definitions" (
  "id" text PRIMARY KEY,
  "activity_id" text NOT NULL,
  "key" text NOT NULL,
  "label" text NOT NULL,
  "type" text NOT NULL,
  "required" boolean NOT NULL,
  "position" integer NOT NULL,
  "constraints" jsonb NOT NULL,
  "comparison_key" text,
  UNIQUE ("activity_id", "key")
);

CREATE TABLE "field_options" (
  "id" text PRIMARY KEY,
  "field_id" text NOT NULL,
  "value" text NOT NULL,
  "label" text NOT NULL,
  "position" integer NOT NULL,
  UNIQUE ("field_id", "value")
);

CREATE TABLE "evidence_types" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "mime_types" jsonb NOT NULL,
  "max_bytes" integer NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "activity_evidence_types" (
  "id" text PRIMARY KEY,
  "activity_id" text NOT NULL,
  "evidence_type_id" text NOT NULL,
  "required" boolean NOT NULL,
  UNIQUE ("activity_id", "evidence_type_id")
);

CREATE TABLE "catalog_versions" (
  "id" text PRIMARY KEY,
  "period_id" text NOT NULL,
  "version" integer NOT NULL,
  "published_at" timestamptz NOT NULL,
  "published_by" text NOT NULL,
  "content" jsonb NOT NULL,
  UNIQUE ("period_id", "version")
);

CREATE TABLE "rubric_configuration" (
  "id" text PRIMARY KEY,
  "catalog_id" text NOT NULL,
  "rubric_id" text NOT NULL,
  "in_plan" boolean NOT NULL,
  "in_report" boolean NOT NULL,
  "required" boolean NOT NULL,
  "position" integer NOT NULL,
  UNIQUE ("catalog_id", "rubric_id")
);

CREATE TABLE "activity_configuration" (
  "id" text PRIMARY KEY,
  "configuration_id" text NOT NULL,
  "activity_id" text NOT NULL,
  "calculation" text NOT NULL,
  "parameters" jsonb NOT NULL,
  "required" boolean NOT NULL,
  "position" integer NOT NULL,
  UNIQUE ("configuration_id", "activity_id")
);

CREATE TABLE "projects" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "funding" text NOT NULL,
  "start" date NOT NULL,
  "end" date,
  UNIQUE ("code")
);

CREATE TABLE "documents" (
  "id" text PRIMARY KEY,
  "teacher_id" text NOT NULL,
  "period_id" text NOT NULL,
  "career_id" text NOT NULL,
  "catalog_id" text NOT NULL,
  "kind" text NOT NULL,
  "state" text NOT NULL,
  "version" integer NOT NULL,
  "revision" integer NOT NULL,
  "created_at" timestamptz NOT NULL,
  "updated_at" timestamptz NOT NULL,
  "submitted_at" timestamptz,
  "approved_at" timestamptz,
  "content" jsonb NOT NULL,
  UNIQUE ("teacher_id", "period_id", "kind")
);

CREATE TABLE "work_plans" (
  "id" text PRIMARY KEY,
  "document_id" text NOT NULL,
  "submitted_version" integer,
  UNIQUE ("document_id")
);

CREATE TABLE "activity_reports" (
  "id" text PRIMARY KEY,
  "document_id" text NOT NULL,
  "plan_document_id" text NOT NULL,
  "plan_version_id" text NOT NULL,
  "current_section" text,
  UNIQUE ("document_id")
);

CREATE TABLE "document_sections" (
  "id" text PRIMARY KEY,
  "document_id" text NOT NULL,
  "rubric_id" text NOT NULL,
  "state" text NOT NULL,
  "confirmed_at" timestamptz,
  UNIQUE ("document_id", "rubric_id")
);

CREATE TABLE "activity_records" (
  "id" text PRIMARY KEY,
  "section_id" text NOT NULL,
  "activity_id" text NOT NULL,
  "project_id" text,
  "origin_id" text,
  "weekly_minutes" numeric NOT NULL,
  "values" jsonb NOT NULL
);

CREATE TABLE "field_values" (
  "id" text PRIMARY KEY,
  "record_id" text NOT NULL,
  "field_id" text NOT NULL,
  "value" jsonb NOT NULL,
  UNIQUE ("record_id", "field_id")
);

CREATE TABLE "selected_options" (
  "id" text PRIMARY KEY,
  "value_id" text NOT NULL,
  "option_id" text NOT NULL,
  UNIQUE ("value_id", "option_id")
);

CREATE TABLE "course_results" (
  "id" text PRIMARY KEY,
  "document_id" text NOT NULL,
  "assignment_id" text NOT NULL,
  "enrolled" integer NOT NULL,
  "passed" integer NOT NULL,
  "justification" text,
  UNIQUE ("document_id", "assignment_id")
);

CREATE TABLE "evidence" (
  "id" text PRIMARY KEY,
  "document_id" text NOT NULL,
  "record_id" text,
  "type_id" text NOT NULL,
  "uploaded_by" text NOT NULL,
  "filename" text NOT NULL,
  "mime" text NOT NULL,
  "bytes" integer NOT NULL,
  "sha256" text NOT NULL,
  "storage_path" text NOT NULL,
  "uploaded_at" timestamptz NOT NULL
);

CREATE TABLE "document_versions" (
  "id" text PRIMARY KEY,
  "document_id" text NOT NULL,
  "number" integer NOT NULL,
  "event" text NOT NULL,
  "actor_id" text NOT NULL,
  "at" timestamptz NOT NULL,
  "content" jsonb NOT NULL,
  "digest" text NOT NULL,
  UNIQUE ("document_id", "number")
);

CREATE TABLE "reviews" (
  "id" text PRIMARY KEY,
  "document_id" text NOT NULL,
  "version_id" text NOT NULL,
  "reviewer_id" text NOT NULL,
  "result" text NOT NULL,
  "comment" text NOT NULL,
  "at" timestamptz NOT NULL
);

CREATE TABLE "review_visits" (
  "id" text PRIMARY KEY,
  "version_id" text NOT NULL,
  "reviewer_id" text NOT NULL,
  "section_key" text NOT NULL,
  "at" timestamptz NOT NULL,
  UNIQUE ("version_id", "reviewer_id", "section_key")
);

CREATE TABLE "observations" (
  "id" text PRIMARY KEY,
  "review_id" text NOT NULL,
  "section_key" text,
  "record_id" text,
  "text" text NOT NULL,
  "resolved_at" timestamptz
);

CREATE TABLE "idempotency_keys" (
  "id" text PRIMARY KEY,
  "actor_id" text NOT NULL,
  "request_key" text NOT NULL,
  "request_hash" text NOT NULL,
  "response" jsonb NOT NULL,
  "created_at" timestamptz NOT NULL,
  UNIQUE ("actor_id", "request_key")
);

CREATE TABLE "indicators" (
  "id" text PRIMARY KEY,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "unit" text NOT NULL,
  "handler" text NOT NULL,
  "confidentiality" text NOT NULL,
  "active" boolean NOT NULL,
  UNIQUE ("code")
);

CREATE TABLE "panels" (
  "id" text PRIMARY KEY,
  "owner_id" text NOT NULL,
  "name" text NOT NULL,
  "scope" text NOT NULL,
  "default_panel" boolean NOT NULL
);

CREATE TABLE "panel_indicators" (
  "id" text PRIMARY KEY,
  "panel_id" text NOT NULL,
  "indicator_id" text NOT NULL,
  "position" integer NOT NULL,
  "filters" jsonb NOT NULL,
  UNIQUE ("panel_id", "indicator_id")
);

CREATE TABLE "credentials" (
  "id" text PRIMARY KEY,
  "user_id" text NOT NULL,
  "password_hash" text NOT NULL,
  "must_change" boolean NOT NULL,
  UNIQUE ("user_id")
);

CREATE TABLE "sessions" (
  "id" text PRIMARY KEY,
  "user_id" text NOT NULL,
  "token_hash" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  "expires_at" timestamptz NOT NULL,
  "revoked_at" timestamptz,
  UNIQUE ("token_hash")
);

CREATE TABLE "change_requests" (
  "id" text PRIMARY KEY,
  "requested_by" text NOT NULL,
  "authorized_by" text,
  "state" text NOT NULL,
  "effective_on" date,
  "content" jsonb NOT NULL,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "system_settings" (
  "id" text PRIMARY KEY,
  "revision" integer NOT NULL,
  "content" jsonb NOT NULL
);

ALTER TABLE "campuses" ADD FOREIGN KEY ("university_id") REFERENCES "universities"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "campuses" ("university_id");

ALTER TABLE "careers" ADD FOREIGN KEY ("campus_id") REFERENCES "campuses"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "careers" ("campus_id");

ALTER TABLE "careers" ADD FOREIGN KEY ("predecessor_id") REFERENCES "careers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "careers" ("predecessor_id");

ALTER TABLE "study_plans" ADD FOREIGN KEY ("career_id") REFERENCES "careers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "study_plans" ("career_id");

ALTER TABLE "study_plans" ADD FOREIGN KEY ("created_by") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "study_plans" ("created_by");

ALTER TABLE "curriculum_semesters" ADD FOREIGN KEY ("study_plan_id") REFERENCES "study_plans"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "curriculum_semesters" ("study_plan_id");

ALTER TABLE "curriculum_subjects" ADD FOREIGN KEY ("semester_id") REFERENCES "curriculum_semesters"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "curriculum_subjects" ("semester_id");

ALTER TABLE "curriculum_subjects" ADD FOREIGN KEY ("subject_id") REFERENCES "subjects"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "curriculum_subjects" ("subject_id");

ALTER TABLE "periods" ADD FOREIGN KEY ("catalog_id") REFERENCES "catalog_versions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "periods" ("catalog_id");

ALTER TABLE "capture_windows" ADD FOREIGN KEY ("period_id") REFERENCES "periods"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "capture_windows" ("period_id");

ALTER TABLE "groups" ADD FOREIGN KEY ("period_id") REFERENCES "periods"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "groups" ("period_id");

ALTER TABLE "groups" ADD FOREIGN KEY ("campus_id") REFERENCES "campuses"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "groups" ("campus_id");

ALTER TABLE "groups" ADD FOREIGN KEY ("semester_id") REFERENCES "curriculum_semesters"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "groups" ("semester_id");

ALTER TABLE "course_offerings" ADD FOREIGN KEY ("group_id") REFERENCES "groups"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "course_offerings" ("group_id");

ALTER TABLE "course_offerings" ADD FOREIGN KEY ("subject_id") REFERENCES "subjects"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "course_offerings" ("subject_id");

ALTER TABLE "teaching_assignments" ADD FOREIGN KEY ("offering_id") REFERENCES "course_offerings"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "teaching_assignments" ("offering_id");

ALTER TABLE "teaching_assignments" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "teaching_assignments" ("teacher_id");

ALTER TABLE "teaching_assignments" ADD FOREIGN KEY ("previous_id") REFERENCES "teaching_assignments"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "teaching_assignments" ("previous_id");

ALTER TABLE "employee_history" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "employee_history" ("user_id");

ALTER TABLE "degrees" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "degrees" ("user_id");

ALTER TABLE "teachers" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "teachers" ("user_id");

ALTER TABLE "teachers" ADD FOREIGN KEY ("category_id") REFERENCES "teacher_categories"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "teachers" ("category_id");

ALTER TABLE "affiliations" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "affiliations" ("teacher_id");

ALTER TABLE "affiliations" ADD FOREIGN KEY ("career_id") REFERENCES "careers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "affiliations" ("career_id");

ALTER TABLE "distinctions" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "distinctions" ("teacher_id");

ALTER TABLE "role_permissions" ADD FOREIGN KEY ("role_id") REFERENCES "roles"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "role_permissions" ("role_id");

ALTER TABLE "role_permissions" ADD FOREIGN KEY ("permission_id") REFERENCES "permissions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "role_permissions" ("permission_id");

ALTER TABLE "role_assignments" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "role_assignments" ("user_id");

ALTER TABLE "role_assignments" ADD FOREIGN KEY ("role_id") REFERENCES "roles"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "role_assignments" ("role_id");

ALTER TABLE "role_assignments" ADD FOREIGN KEY ("campus_id") REFERENCES "campuses"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "role_assignments" ("campus_id");

ALTER TABLE "role_assignments" ADD FOREIGN KEY ("career_id") REFERENCES "careers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "role_assignments" ("career_id");

ALTER TABLE "approval_delegations" ADD FOREIGN KEY ("career_id") REFERENCES "careers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "approval_delegations" ("career_id");

ALTER TABLE "approval_delegations" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "approval_delegations" ("user_id");

ALTER TABLE "approval_delegations" ADD FOREIGN KEY ("assigned_by") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "approval_delegations" ("assigned_by");

ALTER TABLE "audit_events" ADD FOREIGN KEY ("actor_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "audit_events" ("actor_id");

ALTER TABLE "notifications" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "notifications" ("user_id");

ALTER TABLE "notifications" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "notifications" ("document_id");

ALTER TABLE "activity_classifications" ADD FOREIGN KEY ("activity_id") REFERENCES "activities"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_classifications" ("activity_id");

ALTER TABLE "activity_classifications" ADD FOREIGN KEY ("rubric_id") REFERENCES "rubrics"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_classifications" ("rubric_id");

ALTER TABLE "field_definitions" ADD FOREIGN KEY ("activity_id") REFERENCES "activities"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "field_definitions" ("activity_id");

ALTER TABLE "field_options" ADD FOREIGN KEY ("field_id") REFERENCES "field_definitions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "field_options" ("field_id");

ALTER TABLE "activity_evidence_types" ADD FOREIGN KEY ("activity_id") REFERENCES "activities"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_evidence_types" ("activity_id");

ALTER TABLE "activity_evidence_types" ADD FOREIGN KEY ("evidence_type_id") REFERENCES "evidence_types"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_evidence_types" ("evidence_type_id");

ALTER TABLE "catalog_versions" ADD FOREIGN KEY ("period_id") REFERENCES "periods"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "catalog_versions" ("period_id");

ALTER TABLE "catalog_versions" ADD FOREIGN KEY ("published_by") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "catalog_versions" ("published_by");

ALTER TABLE "rubric_configuration" ADD FOREIGN KEY ("catalog_id") REFERENCES "catalog_versions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "rubric_configuration" ("catalog_id");

ALTER TABLE "rubric_configuration" ADD FOREIGN KEY ("rubric_id") REFERENCES "rubrics"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "rubric_configuration" ("rubric_id");

ALTER TABLE "activity_configuration" ADD FOREIGN KEY ("configuration_id") REFERENCES "rubric_configuration"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_configuration" ("configuration_id");

ALTER TABLE "activity_configuration" ADD FOREIGN KEY ("activity_id") REFERENCES "activities"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_configuration" ("activity_id");

ALTER TABLE "documents" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "documents" ("teacher_id");

ALTER TABLE "documents" ADD FOREIGN KEY ("period_id") REFERENCES "periods"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "documents" ("period_id");

ALTER TABLE "documents" ADD FOREIGN KEY ("career_id") REFERENCES "careers"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "documents" ("career_id");

ALTER TABLE "documents" ADD FOREIGN KEY ("catalog_id") REFERENCES "catalog_versions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "documents" ("catalog_id");

ALTER TABLE "work_plans" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "work_plans" ("document_id");

ALTER TABLE "activity_reports" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_reports" ("document_id");

ALTER TABLE "activity_reports" ADD FOREIGN KEY ("plan_document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_reports" ("plan_document_id");

ALTER TABLE "activity_reports" ADD FOREIGN KEY ("plan_version_id") REFERENCES "document_versions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_reports" ("plan_version_id");

ALTER TABLE "document_sections" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "document_sections" ("document_id");

ALTER TABLE "document_sections" ADD FOREIGN KEY ("rubric_id") REFERENCES "rubrics"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "document_sections" ("rubric_id");

ALTER TABLE "activity_records" ADD FOREIGN KEY ("section_id") REFERENCES "document_sections"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_records" ("section_id");

ALTER TABLE "activity_records" ADD FOREIGN KEY ("activity_id") REFERENCES "activities"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_records" ("activity_id");

ALTER TABLE "activity_records" ADD FOREIGN KEY ("project_id") REFERENCES "projects"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_records" ("project_id");

ALTER TABLE "activity_records" ADD FOREIGN KEY ("origin_id") REFERENCES "activity_records"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "activity_records" ("origin_id");

ALTER TABLE "field_values" ADD FOREIGN KEY ("record_id") REFERENCES "activity_records"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "field_values" ("record_id");

ALTER TABLE "field_values" ADD FOREIGN KEY ("field_id") REFERENCES "field_definitions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "field_values" ("field_id");

ALTER TABLE "selected_options" ADD FOREIGN KEY ("value_id") REFERENCES "field_values"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "selected_options" ("value_id");

ALTER TABLE "selected_options" ADD FOREIGN KEY ("option_id") REFERENCES "field_options"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "selected_options" ("option_id");

ALTER TABLE "course_results" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "course_results" ("document_id");

ALTER TABLE "course_results" ADD FOREIGN KEY ("assignment_id") REFERENCES "teaching_assignments"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "course_results" ("assignment_id");

ALTER TABLE "evidence" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "evidence" ("document_id");

ALTER TABLE "evidence" ADD FOREIGN KEY ("record_id") REFERENCES "activity_records"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "evidence" ("record_id");

ALTER TABLE "evidence" ADD FOREIGN KEY ("type_id") REFERENCES "evidence_types"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "evidence" ("type_id");

ALTER TABLE "evidence" ADD FOREIGN KEY ("uploaded_by") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "evidence" ("uploaded_by");

ALTER TABLE "document_versions" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "document_versions" ("document_id");

ALTER TABLE "document_versions" ADD FOREIGN KEY ("actor_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "document_versions" ("actor_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("document_id") REFERENCES "documents"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "reviews" ("document_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("version_id") REFERENCES "document_versions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "reviews" ("version_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("reviewer_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "reviews" ("reviewer_id");

ALTER TABLE "review_visits" ADD FOREIGN KEY ("version_id") REFERENCES "document_versions"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "review_visits" ("version_id");

ALTER TABLE "review_visits" ADD FOREIGN KEY ("reviewer_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "review_visits" ("reviewer_id");

ALTER TABLE "observations" ADD FOREIGN KEY ("review_id") REFERENCES "reviews"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "observations" ("review_id");

ALTER TABLE "observations" ADD FOREIGN KEY ("record_id") REFERENCES "activity_records"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "observations" ("record_id");

ALTER TABLE "idempotency_keys" ADD FOREIGN KEY ("actor_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "idempotency_keys" ("actor_id");

ALTER TABLE "panels" ADD FOREIGN KEY ("owner_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "panels" ("owner_id");

ALTER TABLE "panel_indicators" ADD FOREIGN KEY ("panel_id") REFERENCES "panels"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "panel_indicators" ("panel_id");

ALTER TABLE "panel_indicators" ADD FOREIGN KEY ("indicator_id") REFERENCES "indicators"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "panel_indicators" ("indicator_id");

ALTER TABLE "credentials" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "credentials" ("user_id");

ALTER TABLE "sessions" ADD FOREIGN KEY ("user_id") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "sessions" ("user_id");

ALTER TABLE "change_requests" ADD FOREIGN KEY ("requested_by") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "change_requests" ("requested_by");

ALTER TABLE "change_requests" ADD FOREIGN KEY ("authorized_by") REFERENCES "users"(id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX ON "change_requests" ("authorized_by");

CREATE UNIQUE INDEX one_current_affiliation ON affiliations(teacher_id) WHERE "end" IS NULL;

CREATE UNIQUE INDEX one_current_employee ON employee_history(user_id) WHERE "end" IS NULL;

CREATE UNIQUE INDEX one_current_offering_teacher ON teaching_assignments(offering_id) WHERE "end" IS NULL;

ALTER TABLE periods ADD CHECK ("end" >= start AND effective_weeks > 0 AND nominal_weekly_minutes > 0 AND maximum_weekly_minutes > 0 AND rejection_threshold BETWEEN 0 AND 100);

ALTER TABLE capture_windows ADD CHECK (closes_at >= opens_at AND kind IN ('PLAN','REPORT'));

ALTER TABLE course_results ADD CHECK (enrolled >= 0 AND passed BETWEEN 0 AND enrolled);

ALTER TABLE teaching_assignments ADD CHECK (weekly_minutes > 0 AND students >= 0 AND ("end" IS NULL OR "end" >= start));

ALTER TABLE documents ADD CHECK (kind IN ('PLAN','REPORT') AND state IN ('draft','in_review','returned','approved') AND revision > 0 AND version > 0);

ALTER TABLE degrees ADD CHECK (NOT official OR license IS NOT NULL);

ALTER TABLE evidence ADD CHECK (bytes > 0 AND storage_path NOT LIKE '%..%');

ALTER TABLE approval_delegations ADD CHECK ("end" >= start);

CREATE FUNCTION immutable_row() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN RAISE EXCEPTION 'Registro histórico inmutable'; END $$;

CREATE TRIGGER freeze_catalog BEFORE UPDATE OR DELETE ON catalog_versions FOR EACH ROW EXECUTE FUNCTION immutable_row();

CREATE TRIGGER freeze_versions BEFORE UPDATE OR DELETE ON document_versions FOR EACH ROW EXECUTE FUNCTION immutable_row();

CREATE TRIGGER freeze_audit BEFORE UPDATE OR DELETE ON audit_events FOR EACH ROW EXECUTE FUNCTION immutable_row();

COMMIT;