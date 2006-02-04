<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/anon-eval/www/asm-admin/toggle-anonymous.xql -->
<!-- @author Roel Canicula (roel@solutiongrove.com) -->
<!-- @creation-date 2006-02-04 -->
<!-- @arch-tag: b18fbd11-6436-4338-8e57-fbcbc3572825 -->
<!-- @cvs-id $Id$ -->

<queryset>
  <fullquery name="toggle_anonymous">
    <querytext>
      update as_assessments
      set anonymous_p = (case when anonymous_p = 't' then 'f' else 't' end)
      where assessment_id = :assessment_id
    </querytext>
  </fullquery>
</queryset>