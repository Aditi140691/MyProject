class TestRunnerParallel {

@Test
   void testParallel() {
       Results results = Runner.path("classpath:Features")
                .outputCucumberJson(true)
                 .reportDir("target/retry-test")
                .tags("@testCase1").parallel(1);
        List<ScenarioResult> failed = results.getScenarioResults().filter(sr -> sr.isFailed()).collect(Collectors.toList());
        if(failed.size()>0){
        for(ScenarioResult test: failed){
        Scenario scenario = test.getScenario();
        ScenarioResult sr = results.getSuite().retryScenario(scenario);
        results = results.getSuite().updateResults(sr);
        }
    }

       assertEquals(0, results.getFailCount(),results.getErrorMessages());
   }
}