# /packages/assessment/tcl/as-install-procs.tcl

ad_library {
    Assessment Package callbacks library
    
    Procedures that deal with installing.
}

namespace eval ae::install {}

ad_proc -public ae::install::package_instantiate {
    -package_id:required
} {
    Define folders
    
} {
    # create a content folder
    set folder_id [content::folder::new -name "anon_eval_$package_id" -package_id $package_id ]
    # register the allowed content types for a folder
    content::folder::register_content_type -folder_id $folder_id -content_type {image} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {content_revision} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_choices} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_mc} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_sa_answers} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_sa} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_oq} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_rb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_cb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_sb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_tb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_sa} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_ta} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_items} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_section_display_types} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_sections} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_assessments} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_sessions} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_section_data} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_data} -include_subtypes t

    # Grant read permission on this folder to cascade to sessions
    permission::grant -object_id $folder_id -party_id [acs_magic_object registered_users] -privilege read
}
