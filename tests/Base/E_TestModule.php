<?php
/**
 * Cron test class.
 *
 * @copyright YetiForce Sp. z o.o
 * @license   YetiForce Public License 3.0 (licenses/LicenseEN.txt or yetiforce.com)
 * @author    Mariusz Krzaczkowski <m.krzaczkowski@yetiforce.com>
 */

namespace Tests\Base;

/**
 * @codeCoverageIgnore
 */
class E_TestModule extends \Tests\Base
{
	/**
	 * Testing the installation of the sample data module.
	 */
	public function testInstallSampleData()
	{
		$testModule = 'TestModule.zip';
		try {
			$urlWeb = 'https://tests.yetiforce.com/' . $_SERVER['YETI_KEY'];
			if (\file_exists('./public_html/_private/TestData.zip')) {
				$urlFile = './public_html/_private/TestData.zip';
			} elseif (\App\RequestUtil::isNetConnection() && \strpos(\get_headers($urlWeb)[0], '200') !== false) {
				$urlFile = $urlWeb;
			} else {
				$this->assertTrue(true);
				return;
			}
			\copy($urlFile, $testModule);
			(new \vtlib\Package())->import($testModule);
			$this->assertTrue((new \App\Db\Query())->from('vtiger_tab')->where(['name' => 'TestData'])->exists());
			$db = \App\Db::getInstance();
			$db->createCommand()
				->update('vtiger_cron_task', [
						'sequence' => 0,
					], ['name' => 'TestData'])
				->execute();
		} catch (\Exception $exc) {
		}
	}
}
