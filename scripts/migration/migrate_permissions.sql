-----------------------
-- dataverses role assignments
-----------------------

-- admin (from the vdcnetwork creator)
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, vdc_id, dr.id
	from _dvn3_vdcnetwork vdcn, authenticateduser, dataverserole dr
	where vdcn.creator_id = authenticateduser.id
	and dr.alias='admin';

-- admin (from the vdc creator)
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, vdc_id, dr.id
	from _dvn3_vdc, authenticateduser, dataverserole dr
	where vdc.creator_id = authenticateduser.id
	and dr.alias='admin';

-- admin
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, vdc_id, dr.id
	from _dvn3_vdcrole, authenticateduser, dataverserole dr
	where _dvn3_vdcrole.vdcuser_id = authenticateduser.id
	and role_id=3 and dr.alias='admin';
-- curator
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, vdc_id, dr.id
	from _dvn3_vdcrole, authenticateduser, dataverserole dr
	where _dvn3_vdcrole.vdcuser_id = authenticateduser.id
	and role_id=2 and dr.alias='curator';
-- contributor
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, vdc_id, dr.id
	from _dvn3_vdcrole, authenticateduser, dataverserole dr
	where _dvn3_vdcrole.vdcuser_id = authenticateduser.id
	and role_id=1 and dr.alias='dsContributor';
-- member
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, vdc_id, dr.id
	from _dvn3_vdcrole, authenticateduser, dataverserole dr
	where _dvn3_vdcrole.vdcuser_id = authenticateduser.id
	and role_id=4 and dr.alias='member';

-- groups (as members)
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'&'|| groupalias, vdcs_id, dr.id
	from _dvn3_vdc_usergroup, explicitgroup, dataverserole dr
	where _dvn3_vdc_usergroup.allowedgroups_id = explicitgroup.id
	and dr.alias='member';

-----------------------
-- dataset role assignments
-----------------------

-- contributor (from the study creator)
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, ds.id, dr.id
	from _dvn3_study s, authenticateduser, dataverserole dr, datset ds
	where s.creator_id = authenticateduser.id
        and ds.authority = s.authority
        and ds.protocol = s.protocol
        and ds.identifier = s.studyid 
	and dr.alias='editor';

-- member
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, ds.id, dr.id
	from _dvn3_study_vdcuser, _dvn3_study s, authenticateduser, dataverserole dr, datset ds
	where _dvn3_study_vdcuser.allowedusers_id = authenticateduser.id
        and ds.authority = s.authority
        and ds.protocol = s.protocol
        and ds.identifier = s.studyid 
	and dr.alias='member';

-- groups (as members)
insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'&'|| groupalias, ds.id, dr.id
	from _dvn3_study_usergroup, _dvn3_study s, explicitgroup, dataverserole dr, dataset ds
	where _dvn3_study_usergroup.allowedgroups_id = explicitgroup.id
        and ds.authority = s.authority
        and ds.protocol = s.protocol
        and ds.identifier = s.studyid 
	and dr.alias='member';

-----------------------
-- file role assignments
-----------------------

insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'@'|| useridentifier, studyfiles_id, dr.id
	from _dvn3_studyfile_vdcuser, authenticateduser, dataverserole dr
	where _dvn3_studyfile_vdcuser.allowedusers_id = authenticateduser.id
	and dr.alias='fileDownloader';

insert into roleassignment (	assigneeidentifier, definitionpoint_id, role_id)
	select 			'&'|| groupalias, studyfiles_id, dr.id
	from _dvn3_studyfile_usergroup, explicitgroup, dataverserole dr
	where _dvn3_studyfile_usergroup.allowedgroups_id = explicitgroup.id
	and dr.alias='fileDownloader';


