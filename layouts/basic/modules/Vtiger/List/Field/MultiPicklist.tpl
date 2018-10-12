{*<!--
/*********************************************************************************
** The contents of this file are subject to the vtiger CRM Public License Version 1.0
* ("License"); You may not use this file except in compliance with the License
* The Original Code is:  vtiger CRM Open Source
* The Initial Developer of the Original Code is vtiger.
* Portions created by vtiger are Copyright (C) vtiger.
* All Rights Reserved.
*
********************************************************************************/
-->*}
{strip}
	{assign var="FIELD_INFO" value=\App\Json::encode($FIELD_MODEL->getFieldInfo())}
	{assign var=PICKLIST_VALUES value=$FIELD_MODEL->getPicklistValues(true)}
	{if isset($SEARCH_INFO['searchValue'])}
		{assign var=SEARCH_VALUES value=explode('##', \App\Purifier::decodeHtml($SEARCH_INFO['searchValue']))}
	{else}
		{assign var=SEARCH_VALUES value=[]}
	{/if}
	<div class="tpl-List-Field-MultiPicklist picklistSearchField">
		<select name="{$FIELD_MODEL->getName()}"
				class="select2noactive listSearchContributor"
				title="{\App\Language::translate($FIELD_MODEL->getFieldLabel(), $MODULE)}"
				multiple="multiple"
				data-fieldinfo='{$FIELD_INFO|escape}'>
			{foreach item=PICKLIST_LABEL key=PICKLIST_KEY from=$PICKLIST_VALUES}
				<option value="{\App\Purifier::encodeHtml($PICKLIST_KEY)}" {if in_array($PICKLIST_KEY,$SEARCH_VALUES) && ($PICKLIST_KEY neq "")} selected{/if}>{\App\Purifier::encodeHtml($PICKLIST_LABEL)}</option>
			{/foreach}
		</select>
	</div>
{/strip}
