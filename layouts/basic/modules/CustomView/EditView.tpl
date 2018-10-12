{*<!--
/*********************************************************************************
** The contents of this file are subject to the vtiger CRM Public License Version 1.0
* ("License"); You may not use this file except in compliance with the License
* The Original Code is: vtiger CRM Open Source
* The Initial Developer of the Original Code is vtiger.
* Portions created by vtiger are Copyright (C) vtiger.
* All Rights Reserved.
* Contributor(s): YetiForce.com
********************************************************************************/
-->*}
{strip}
	<div class="tpl-CustomView-EditView modal fade js-filter-modal__container" tabindex="-1" data-js="container">
		<div class="modal-dialog modal-fullscreen">
			<div class="modal-content pl-3 pr-3">
				<div class="modal-header">
					<h5 class="modal-title">
						<span class="fas fa-filter fa-sm mr-1"></span>
						{\App\Language::translate('LBL_CREATE_NEW_FILTER')}
					</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<form class="form-horizontal" id="CustomView" name="CustomView" method="post" action="index.php">
					{if !empty($RECORD_ID)}
						<input type="hidden" name="record" id="record" value="{$RECORD_ID}"/>
					{/if}
					<input type="hidden" name="module" value="{$MODULE_NAME}"/>
					<input type="hidden" name="action" value="Save"/>
					<input type="hidden" name="source_module" value="{$SOURCE_MODULE}"/>
					<input type="hidden" id="stdfilterlist" name="stdfilterlist" value=""/>
					<input type="hidden" id="advfilterlist" name="advfilterlist" value=""/>
					<input type="hidden" id="status" name="status" value="{$CV_PRIVATE_VALUE}"/>
					<input type="hidden" id="sourceModule" value="{$SOURCE_MODULE}"/>
					<input type="hidden" name="date_filters"
						   data-value="{\App\Purifier::encodeHtml(\App\Json::encode($DATE_FILTERS))}"/>
					{assign var=SELECTED_FIELDS value=$CUSTOMVIEW_MODEL->getSelectedFields()}
					<div class="childrenMarginTopX">
						<div class="js-toggle-panel c-panel" data-js="click">
							<div class="blockHeader  c-panel__header">
					<span class="iconToggle fas fa-chevron-down small m-1 mt-2" data-hide="fas fa-chevron-right"
						  data-show="fas fa-chevron-down"></span>
								<h5 class="">{\App\Language::translate('LBL_BASIC_DETAILS',$MODULE_NAME)}</h5>
							</div>
							<div class="c-panel__body py-1">
								<div class="form-group">
									<div class="row col-md-5">
										<label class="float-left col-form-label "><span
													class="redColor">*</span> {\App\Language::translate('LBL_VIEW_NAME',$MODULE_NAME)}
											:</label>
										<div class="col-md-7">
											<input type="text" id="viewname" class="form-control"
												   data-validation-engine="validate[required]" name="viewname"
												   value="{$CUSTOMVIEW_MODEL->get('viewname')}"/>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class=" col-form-label"><span
												class="redColor">*</span> {\App\Language::translate('LBL_CHOOSE_COLUMNS',$MODULE_NAME)}
										({\App\Language::translate('LBL_MAX_NUMBER_FILTER_COLUMNS')}):</label>
									<div class="columnsSelectDiv col-md-12">
										{assign var=MANDATORY_FIELDS value=[]}
										<div class="">
											<select data-placeholder="{\App\Language::translate('LBL_ADD_MORE_COLUMNS',$MODULE_NAME)}"
													multiple="multiple"
													class="select2 form-control js-select2-sortable js-view-columns-select"
													id="viewColumnsSelect"
													data-js="appendTo">
												{foreach key=BLOCK_LABEL item=BLOCK_FIELDS from=$RECORD_STRUCTURE}
													<optgroup	label="{\App\Language::translate($BLOCK_LABEL, $SOURCE_MODULE)}">
														{foreach key=FIELD_NAME item=FIELD_MODEL from=$BLOCK_FIELDS}
															{if $FIELD_MODEL->isMandatory()}
																{array_push($MANDATORY_FIELDS, $FIELD_MODEL->getCustomViewSelectColumnName())}
															{/if}
															{assign var=ELEMENT_POSITION_IN_ARRAY value=array_search($FIELD_MODEL->getCustomViewSelectColumnName(), $SELECTED_FIELDS)}
															<option value="{$FIELD_MODEL->getCustomViewSelectColumnName()}"
																	data-field-name="{$FIELD_NAME}"
																	{if $ELEMENT_POSITION_IN_ARRAY !== false}
																		data-sort-index="{$ELEMENT_POSITION_IN_ARRAY}" selected="selected"
																	{/if}
																	data-js="data-sort-index|data-field-name">
																{\App\Language::translate($FIELD_MODEL->getFieldLabel(), $SOURCE_MODULE)}
																{if $FIELD_MODEL->isMandatory() eq true}
																	<span>*</span>
																{/if}
															</option>
														{/foreach}
													</optgroup>
												{/foreach}
												{foreach key=MODULE_KEY item=RECORD_STRUCTURE_FIELD from=$RECORD_STRUCTURE_RELATED_MODULES}
													{foreach key=RELATED_FIELD_NAME item=RECORD_STRUCTURE from=$RECORD_STRUCTURE_FIELD}
														{assign var=RELATED_FIELD_LABEL value=Vtiger_Field_Model::getInstance($RELATED_FIELD_NAME, Vtiger_Module_Model::getInstance($SOURCE_MODULE))->getFieldLabel()}
														{foreach key=BLOCK_LABEL item=BLOCK_FIELDS from=$RECORD_STRUCTURE}
															<optgroup
																	label="{\App\Language::translate($RELATED_FIELD_LABEL, $SOURCE_MODULE)}&nbsp;-&nbsp;{\App\Language::translate($MODULE_KEY, $MODULE_KEY)}&nbsp;-&nbsp;{\App\Language::translate($BLOCK_LABEL, $MODULE_KEY)}">
																{foreach key=FIELD_NAME item=FIELD_MODEL from=$BLOCK_FIELDS}
																	{assign var=ELEMENT_POSITION_IN_ARRAY value=array_search($FIELD_MODEL->getCustomViewSelectColumnName($RELATED_FIELD_NAME), $SELECTED_FIELDS)}
																	<option value="{$FIELD_MODEL->getCustomViewSelectColumnName($RELATED_FIELD_NAME)}"
																			data-field-name="{$FIELD_NAME}"
																			{if $ELEMENT_POSITION_IN_ARRAY !== false}
																				data-sort-index="{$ELEMENT_POSITION_IN_ARRAY}" selected="selected"
																			{/if}
																			data-js="data-sort-index|data-field-name">
																	>{\App\Language::translate($RELATED_FIELD_LABEL, $SOURCE_MODULE)}&nbsp;-&nbsp;{\App\Language::translate($FIELD_MODEL->getFieldLabel(), $MODULE_KEY)}
																	</option>
																{/foreach}
															</optgroup>
														{/foreach}
													{/foreach}
												{/foreach}
											</select>
										</div>
										<input type="hidden" name="columnslist"
											   value="{\App\Purifier::encodeHtml(\App\Json::encode($SELECTED_FIELDS))}"
											   class="js-columnslist"
											   data-js="val"/>
										<input id="mandatoryFieldsList" type="hidden"
											   value="{\App\Purifier::encodeHtml(\App\Json::encode($MANDATORY_FIELDS))}"/>
									</div>
								</div>
								<div class="form-group marginbottomZero">
									<div class="row col-md-5">
										<label class="float-left col-form-label ">{\App\Language::translate('LBL_COLOR_VIEW',$MODULE_NAME)}
											:</label>
										<div class="col-md-7">
											<div class="input-group js-color-picker" data-js="color-picker">
												<input type="text" class="form-control" name="color"
													   value="{$CUSTOMVIEW_MODEL->get('color')}"/>
												<div class="input-group-append">
													<div class="input-group-text colorpicker-input-addon"><i></i></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="js-toggle-panel c-panel" data-js="click">
							<div class="blockHeader c-panel__header">
					<span class="iconToggle fas fa-chevron-right small m-1 mt-2" data-hide="fas fa-chevron-right"
						  data-show="fas fa-chevron-down"></span>
								<h5 class="">{\App\Language::translate('LBL_DESCRIPTION_INFORMATION',$MODULE_NAME)}</h5>
							</div>
							<div class="c-panel__body py-1 d-none">
								<textarea name="description" id="description" class="js-editor"
										  data-js="ckeditor">{$CUSTOMVIEW_MODEL->get('description')}</textarea>
							</div>
						</div>
						<div class="js-toggle-panel c-panel" data-js="click">
							<div class="blockHeader c-panel__header">
					<span class="iconToggle fas fa-chevron-down small m-1 mt-2" data-hide="fas fa-chevron-right"
						  data-show="fas fa-chevron-down"></span>
								<h5 class="">{\App\Language::translate('LBL_CHOOSE_FILTER_CONDITIONS', $MODULE_NAME)}
									:</h5>
							</div>
							<div class="c-panel__body py-1">
								<div class="filterConditionsDiv">
									<div class="row">
							<span class="col-md-12">
								{include file=\App\Layout::getTemplatePath('AdvanceFilter.tpl')}
							</span>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer d-flex flex-md-row flex-column justify-content-start px-0">
						<div class="w-75 btn-group js-filter-preferences btn-group-toggle flex-wrap align-items-stretch mt-1  c-btn-block-sm-down pl-1 flex-xl-row flex-column"
							 data-toggle="buttons" data-js="change">
							<label class="c-btn-block-sm-down btn btn-outline-dark{if $CUSTOMVIEW_MODEL->isDefault()} active{/if}"
								   title="{\App\Language::translate('LBL_SET_AS_DEFAULT',$MODULE_NAME)}">
								<input name="setdefault" value="1" type="checkbox"
									   class="js-filter-preference"
									   data-js="change"
									   {if $CUSTOMVIEW_MODEL->isDefault()}checked="checked"{/if}
									   id="setdefault"
									   autocomplete="off"/>
								<span class="{if $CUSTOMVIEW_MODEL->isDefault()}fas{else}far{/if} fa-heart mr-1"
									  data-check="fas fa-heart" data-unchecked="far fa-heart"
									  data-fa-transform="grow-2"></span>
								{\App\Language::translate('LBL_SET_AS_DEFAULT',$MODULE_NAME)}

							</label>
							<label class="c-btn-block-sm-down mt-1 mt-sm-0 btn btn-outline-dark{if $CUSTOMVIEW_MODEL->isSetPublic()} active{/if}"
								   title="{\App\Language::translate('LBL_SET_AS_PUBLIC',$MODULE_NAME)}">
								<input name="status" {if $CUSTOMVIEW_MODEL->isSetPublic()} value="{$CUSTOMVIEW_MODEL->get('status')}" checked="checked" {else} value="{$CV_PENDING_VALUE}" {/if}
									   type="checkbox" class="js-filter-preference" data-js="change"
									   id="status"
									   autocomplete="off"/>
								<span class="far {if $CUSTOMVIEW_MODEL->isSetPublic()}fa-eye{else}fa-eye-slash{/if} mr-1"
									  data-check="fa-eye" data-unchecked="fa-eye-slash"
									  data-fa-transform="grow-2"></span>
								{\App\Language::translate('LBL_SET_AS_PUBLIC',$MODULE_NAME)}
							</label>
							<label class="c-btn-block-sm-down mt-1 mt-sm-0 btn btn-outline-dark{if $CUSTOMVIEW_MODEL->isFeatured(true)} active{/if}"
								   title="{\App\Language::translate('LBL_FEATURED',$MODULE_NAME)}">
								<input name="featured" value="1" type="checkbox"
									   class="js-filter-preference"
									   data-js="change" id="featured"
										{if $CUSTOMVIEW_MODEL->isFeatured(true)} checked="checked"{/if}
									   autocomplete="off"/>
								<span class="{if $CUSTOMVIEW_MODEL->isFeatured(true)}fas{else}far{/if} fa-star mr-1"
									  data-check="fas" data-unchecked="far"
									  data-fa-transform="grow-2"></span>
								{\App\Language::translate('LBL_FEATURED',$MODULE_NAME)}
							</label>
							<label class="c-btn-block-sm-down mt-1 mt-sm-0 btn btn-outline-dark{if $CUSTOMVIEW_MODEL->get('setmetrics')} active{/if}"
								   title="{\App\Language::translate('LBL_LIST_IN_METRICS',$MODULE_NAME)}">
								<input name="setmetrics" value="1" type="checkbox"
									   class="js-filter-preference"
									   data-js="change"
									   {if $CUSTOMVIEW_MODEL->get('setmetrics') eq '1'}checked="checked"{/if}
									   id="setmetrics" autocomplete="off"/>
								<span class="fa-layers fa-fw mr-2">
								<span class="fas fa-chart-pie" data-fa-transform="shrink-5 up-6"></span>
								<span class="fas fa-chart-line" data-fa-transform="shrink-5 right-7 down-6"></span>
								<span class="fas fa-chart-area" data-fa-transform="shrink-5 left-7 down-6"></span>
							</span>
								{\App\Language::translate('LBL_LIST_IN_METRICS',$MODULE_NAME)}
							</label>
						</div>
						<div class="w-25 d-flex flex-wrap flex-md-nowrap justify-content-end  pr-0 mt-1  c-btn-block-sm-down ml-0 pr-1 pr-md-0">

							<button class="btn btn-success mr-md-1" type="submit">
								<span class="fa fa-check u-mr-5px"></span>{\App\Language::translate('LBL_SAVE', $MODULE_NAME)}
							</button>
							<button class="btn btn-danger mt-1 mt-md-0" type="reset" data-dismiss="modal">
								<span
										class="fa fa-times u-mr-5px"></span>{\App\Language::translate('LBL_CANCEL', $MODULE_NAME)}
							</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
{/strip}
